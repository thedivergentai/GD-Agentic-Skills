# Aurelius Protocol: Project Foundations NEVER List

- **NEVER group by file type** —  `/scripts`, `/sprites` folders. Nightmare maintainability. Use feature-based: `/player`, `/ui`.
- **NEVER mix snake_case and PascalCase in files** — Standard: snake_case for files, PascalCase for nodes.
- **NEVER use hardcoded get_node() paths** — Brittle on reparenting. Use `%SceneUniqueNames` for stable references.
- **NEVER use monolithic Autoloads** — Avoid managers that hold visual node references; keep singletons focused on pure data or RefCounted delegation.
- **NEVER forget .gitignore**  — Committing `.godot/` folder = 100MB+ bloat + conflicts.
- **NEVER skip .gdignore for raw assets** — Design source files (`.psd`, `.blend`) in root will be imported unless ignored.
- **NEVER modify globally shared Resources directly** — Strictly call `duplicate(true)` for unique instances with independent state.
- **NEVER block the main thread with `load()`** — Strictly use `ResourceLoader.load_threaded_request()` for async scene transitions.
- **NEVER modify the SceneTree from a background thread** — Strictly use `call_deferred()` for thread-to-main-thread synchronization.
- **NEVER skip Mutex locking during pooled access** — Strictly ensure thread-safety when using a shared `WorkerThreadPool` or Object Pool.
- **NEVER use `_process()` for precise input** — Tied to visual framerate. Strictly use `_unhandled_input()` to capture exact, frame-independent events.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/editor/project_settings.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
