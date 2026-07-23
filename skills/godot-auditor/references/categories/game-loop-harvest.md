# Aurelius Protocol: Game Loop Harvest NEVER List

- **NEVER use float variables to store massively accumulated harvest resources** — Large floats lose precision, which can lead to "missing" resources in idle/clicker games. Always use `int` for core counts.
- **NEVER process gathering logic in _process() without multiplying rates by delta** — If you don't use `delta`, the harvesting speed will fluctuate wildly based on the player's hardware performance/framerate.
- **NEVER run heavy array mathematics for thousands of resources on the main thread** — This will cause micro-stutters. Distribute heavy calculations using `WorkerThreadPool`.
- **NEVER leave a gathering game running at full GPU utilization** — For UI-heavy harvest games, enable `OS.low_processor_usage_mode` to drastically reduce battery drain on mobile/laptops.
- **NEVER trust OS.get_ticks_msec() for offline progress** — This only tracks system uptime. Rely on `Time.get_unix_time_from_system()` to calculate real-world time passed between sessions.
- **NEVER use Timer nodes for precise audio-visual harvesting synchronization** — Timer nodes are subject to framerate variations. For frame-perfect sync, use code-based timers or the animation system.
- **NEVER couple your resource logic directly to UI counters** — Use a signal bus or event system to notify the UI of changes, keeping the game logic decoupled from the presentation.
- **NEVER constantly instantiate and destroy Label nodes for "floating numbers"** — Frequent allocation/deallocation leads to memory fragmentation. Use an object pool for damage/harvest popups.
- **NEVER modify a globally shared Resource without calling duplicate()** — If you modify a shared `Resource` (like a base crop yield), every instance using that resource will be updated. Use `duplicate(true)`.
- **NEVER access shared harvest data from background threads without a Mutex** — Simultaneous access will eventually corrupt your inventory data. Always use a `Mutex` to lock sensitive blocks.
- **NEVER hardcode yield values in your gathering scripts** — Use exports and custom `Resource` files so designers can balance the economy without touching the code.
- **NEVER use queue_free() on a harvested node before the VFX/SFX finish** — You'll cut off the "juice." Hide the mesh and disable collision, then `queue_free()` once the effect signals completion.
- **NEVER check tool requirements via string comparisons if possible** — Use enums or class types. Strings are prone to typos and are slower for high-frequency checks.
- **NEVER neglect to save the UNIX timestamp on exit** — If you forget this, you lose the ability to calculate offline earnings when the player returns.
- **NEVER scale collision shapes non-uniformly for harvestable objects** — This breaks the underlying physics calculations. Adjust the shape resource dimensions instead.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
