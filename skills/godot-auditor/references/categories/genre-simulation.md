# Aurelius Protocol: Genre Simulation NEVER List

- NEVER use floating-point for primary currency; strictly use **Integer Cents** (or fixed-point math) to prevent accumulated precision errors in financial models.
- NEVER process 1000+ entities individually in `_process()`; strictly use a **Tick Manager** to batch updates or process entities in rotating pools.
- NEVER rely on linear cost scaling; strictly use **Exponential Growth** (`Base * pow(1.15, Level)`) to maintain challenge and strategic tension.
- NEVER hide critical metrics from the player; strictly provide **Detailed Breakdowns** (Income vs. Expense) so players can make optimization-based decisions.
- NEVER allow infinite resource stacking; strictly enforce **Logistical Caps** (warehouses/silos) to create meaningful space-management gameplay loops.
- NEVER let the early game become a "Waiting Simulator"; strictly **Front-Load Decisions** and quick early wins to build player momentum.
- NEVER modify a shared Resource directly; strictly use **`duplicate()`** to avoid unintentionally updating every building of that type.
- NEVER tie simulation logic to the visual framerate; strictly use **`_physics_process()`** or delta accumulators for deterministic simulation results.
- NEVER update UI labels every frame; strictly use **Event-Driven Signals** to refresh UI ONLY when the underlying data changes.
- NEVER run heavy economic loops synchronously; strictly use **WorkerThreadPool** to offload complex calculations and prevent UI stutters.
- NEVER store massive resource data as Nodes; strictly use **`RefCounted`** or **Data Resources** to avoid the memory/CPU overhead of the SceneTree.
- NEVER ignore **`OS.low_processor_usage_mode`**; strictly enable it for stationary management screens to save massive CPU/Battery life.
- NEVER manipulate the SceneTree from background threads; strictly use **`call_deferred()`** for thread-safe UI updates.
- NEVER parse large JSON save files on the main thread; strictly use **Threaded Serialization** or optimized binary `.res` formats.
- NEVER use standard equality (==) for needs; strictly use **`is_equal_approx()`** to prevent floating-point jitter failures in logic gates.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-simulation/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
