# Aurelius Protocol: Resource Data Patterns NEVER List

- **NEVER modify resource instances directly** — Without `.duplicate()`, changing a value (like HP) modifies the `.tres` file on disk for everyone [26].
- **NEVER use untyped arrays in Resources** — `@export var items: Array` allows logic errors. Always use `Array[ResourceClass]` for type safety [27].
- **NEVER store Node references in Resources** — Objects that only exist in a specific SceneTree (like Players/Projectiles) cannot be serialized. Store `NodePath` or `UID` [30].
- **NEVER perform heavy calculations in Resource getters/setters** — Resources should be data containers. Offload logic to Nodes or specialized RefCounted classes.
- **NEVER skip `ResourceSaver.save()` error checks** — Saving can fail due to permissions, disk space, or path issues. Always check the return code [31].
- **NEVER use Resources for high-frequency runtime data** — If a value changes 60 times a second (like velocity), a standard variable is faster than a Resource property.
- **NEVER allow circular Resource references** — If A.tres references B.tres and B.tres references A.tres, the engine may crash on load.
- **NEVER forget the `_init` defaults** — Resources created via `new()` or in the Inspector need default values in their constructor to be editable [15].
- **NEVER share a Resource between entities if they need unique state** — Use `resource_local_to_scene = true` in the Inspector for components [26].
- **NEVER use `.tres` for massive datasets** — If you have 10,000 items, a JSON or custom binary format might be more efficient than individualized Resource files.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
