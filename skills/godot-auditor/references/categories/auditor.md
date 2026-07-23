# Aurelius Protocol: Auditor NEVER List

- **NEVER** use `get_parent()`. It assumes structural dominance that you do not have. Use Signals (upward) or Exports (downward).
- **NEVER** use `Input.is_action_pressed` in `_process` for non-continuous actions. Use `_unhandled_input` to avoid polling overhead.
- **NEVER** store gameplay state in a AutoLoad without strict type-hinting. Singletons are global pollutants if untyped.
- **NEVER** use absolute NodePaths (`/root/Main/Player`). If the structure moves 1 inch, your code dies. Use Groups or Unique Names.
- **NEVER** export a `Node` variable without a specific class hint (`@export var player: Player` NOT `@export var player: Node`). Refuses to allow slop in the Inspector.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
