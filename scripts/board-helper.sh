#!/bin/bash
# board-helper.sh - Manipulate projects.json without loading entire file into context
# Usage:
#   board-helper.sh list                     - List project IDs and titles
#   board-helper.sh get <id>                 - Get a specific project
#   board-helper.sh add <json-file>          - Add a new project from JSON file
#   board-helper.sh update <id> <json-file>  - Update a project from JSON file
#   board-helper.sh set-priority <id> <1-4>  - Set project priority
#   board-helper.sh set-status <id> <status> - Set project status

PROJECTS_FILE="$HOME/projects/aurora-projects/dist/projects.json"

case "$1" in
  list)
    jq -r '.projects[] | "\(.id)\t\(.status)\t\(.priority)\t\(.title)"' "$PROJECTS_FILE" | column -t -s $'\t'
    ;;

  get)
    if [ -z "$2" ]; then
      echo "Usage: board-helper.sh get <project-id>"
      exit 1
    fi
    jq --arg id "$2" '.projects[] | select(.id == $id)' "$PROJECTS_FILE"
    ;;

  add)
    if [ -z "$2" ]; then
      echo "Usage: board-helper.sh add <json-file>"
      echo "JSON file should contain a single project object"
      exit 1
    fi
    # Validate the input JSON
    if ! jq empty "$2" 2>/dev/null; then
      echo "Error: Invalid JSON in $2"
      exit 1
    fi
    # Add the new project
    jq --slurpfile new "$2" '.projects += $new' "$PROJECTS_FILE" > "$PROJECTS_FILE.tmp" && \
      mv "$PROJECTS_FILE.tmp" "$PROJECTS_FILE"
    echo "Added project: $(jq -r '.id' "$2")"
    ;;

  update)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: board-helper.sh update <project-id> <json-file>"
      exit 1
    fi
    # Validate the input JSON
    if ! jq empty "$3" 2>/dev/null; then
      echo "Error: Invalid JSON in $3"
      exit 1
    fi
    # Update the project
    jq --arg id "$2" --slurpfile upd "$3" \
      '(.projects[] | select(.id == $id)) |= ($upd[0] + {id: $id})' \
      "$PROJECTS_FILE" > "$PROJECTS_FILE.tmp" && \
      mv "$PROJECTS_FILE.tmp" "$PROJECTS_FILE"
    echo "Updated project: $2"
    ;;

  set-priority)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: board-helper.sh set-priority <project-id> <priority>"
      exit 1
    fi
    jq --arg id "$2" --argjson priority "$3" \
      '(.projects[] | select(.id == $id)).priority = $priority' \
      "$PROJECTS_FILE" > "$PROJECTS_FILE.tmp" && \
      mv "$PROJECTS_FILE.tmp" "$PROJECTS_FILE"
    echo "Set priority $3 for: $2"
    ;;

  set-status)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: board-helper.sh set-status <project-id> <status>"
      echo "Statuses: backlog, up-next, in-progress, done"
      exit 1
    fi
    jq --arg id "$2" --arg status "$3" \
      '(.projects[] | select(.id == $id)).status = $status' \
      "$PROJECTS_FILE" > "$PROJECTS_FILE.tmp" && \
      mv "$PROJECTS_FILE.tmp" "$PROJECTS_FILE"
    echo "Set status '$3' for: $2"
    ;;

  *)
    echo "board-helper.sh - Manage projects.json efficiently"
    echo ""
    echo "Commands:"
    echo "  list                      List all projects (id, status, priority, title)"
    echo "  get <id>                  Get full details of a project"
    echo "  add <json-file>           Add a new project from JSON file"
    echo "  update <id> <json-file>   Update a project from JSON file"
    echo "  set-priority <id> <1-4>   Set project priority"
    echo "  set-status <id> <status>  Set project status"
    echo ""
    echo "Example - Add new project:"
    echo "  echo '{\"id\":\"my-project\",\"title\":\"My Title\",\"status\":\"backlog\",\"priority\":2,\"summary\":\"...\",\"details\":\"...\"}' > /tmp/new-project.json"
    echo "  board-helper.sh add /tmp/new-project.json"
    ;;
esac
