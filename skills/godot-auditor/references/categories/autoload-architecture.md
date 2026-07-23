# Aurelius Protocol: Autoload Architecture NEVER List

- **NEVER access AutoLoads in `_init()`** — AutoLoads are initialized sequentially. Accessing one in `_init()` may find a null reference [12].
- **NEVER modify a Singleton's size or children in `_ready()`** — If multiple Singletons refer to each other's trees during boot, it can cause layout/sorting errors.
- **NEVER store highly localized, scene-specific data in AutoLoads** — This creates "God Objects" and introduces global side effects that are hard to debug [14].
- **NEVER use `Parent.method()` calls from an Autoload** — Autoloads sit at the root. They are the ultimate "top". Use signals to talk to the active scene.
- **NEVER use an Autoload for pure data containers** — If you don't need `_process()` or signals, use a `static var` in a `class_name` script instead [7].
- **NEVER create circular dependencies between Singletons** — If A needs B and B needs A, Godot will hang during the splash screen [13].
- **NEVER free an Autoload node manually** — Removing a singleton from the root can leave dangling references that crash the engine.
- **NEVER use AutoLoads for UI elements that aren't global** — Popups that only exist in one level should be in that level, not a global singleton.
- **NEVER assume `get_tree().current_scene` is accurate in `_ready()`** — In Autoloads, the active scene might still be initializing. Access it via `get_tree().root.get_child(-1)` [6].
- **NEVER skip `process_mode` configuration** — If your global console or music manager needs to work while the game is paused, set `process_mode = PROCESS_MODE_ALWAYS`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — coupling/decoupling patterns for this sector
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
