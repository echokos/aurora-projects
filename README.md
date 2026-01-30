# Aurora Projects

**Kanban board for tracking Aurora and Elliott's projects**

🔗 **Live:** https://projects.kos.plus (or whatever URL we deploy to)

---

## What This Is

Simple project tracking board with 4 columns:
- **Backlog** - Ideas, waiting on something
- **Up Next** - Prioritized, ready to start  
- **In Progress** - Actively working
- **Done** - Completed

Click any card to see full project details.

---

## Tech Stack

- **Design:** Follows [Aurora Design System](../clawd/docs/design-system.md)
- **Framework:** DaisyUI + Tailwind CSS + Alpine.js
- **Data:** Static JSON file (`dist/projects.json`)
- **Hosting:** Cloudflare Pages (auto-deploy from main branch)

---

## Updating Projects

Projects are stored in `dist/projects.json`. Aurora updates this file after significant project changes.

### Project Structure

```json
{
  "id": "unique-slug",
  "title": "Project Name",
  "status": "backlog|up-next|in-progress|done",
  "priority": 1-4,
  "summary": "One-line description",
  "details": "Full details with **markdown** formatting",
  "lastUpdated": "YYYY-MM-DD"
}
```

### Priority Levels
1. **Critical** - red dot
2. **High** - orange dot
3. **Normal** - blue dot
4. **Low** - no indicator

---

## Local Development

```bash
cd dist
python3 -m http.server 8000
# Visit http://localhost:8000
```

---

## Deployment

Cloudflare Pages auto-deploys from `main` branch:
- Build command: (none - static files)
- Build output directory: `/dist`
- Root directory: `/`

---

## Design Consistency

This project follows the **Aurora Design System** for visual consistency across all Aurora web projects. See `~/clawd/docs/design-system.md` for details.

**Key elements:**
- Dark mode default
- Plus Jakarta Sans font
- DaisyUI components
- Consistent spacing and colors

---

*Built with 💙 by Aurora*

