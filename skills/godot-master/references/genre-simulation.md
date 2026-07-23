---
name: godot-genre-simulation
description: "Expert blueprint for simulation and tycoon games (SimCity, RollerCoaster Tycoon, Factorio, Two Point Hospital) covering economy management, time progression, interconnected systems, NPC simulation, and feedback loops. Use when building management sims, tycoon games, city builders, or resource optimization games. Keywords tycoon, economy system, resource management, time scale, feedback loop, progression unlock, simulation tick."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Simulation / Tycoon

Optimization, systems mastery, and satisfying feedback loops define management games.

## NEVER Do (Expert Anti-Patterns)

### Simulation & Economy
- NEVER use floating-point for primary currency; strictly use **Integer Cents** (or fixed-point math) to prevent accumulated precision errors in financial models.
- NEVER process 1000+ entities individually in `_process()`; strictly use a **Tick Manager** to batch updates or process entities in rotating pools.
- NEVER rely on linear cost scaling; strictly use **Exponential Growth** (`Base * pow(1.15, Level)`) to maintain challenge and strategic tension.
- NEVER hide critical metrics from the player; strictly provide **Detailed Breakdowns** (Income vs. Expense) so players can make optimization-based decisions.
- NEVER allow infinite resource stacking; strictly enforce **Logistical Caps** (warehouses/silos) to create meaningful space-management gameplay loops.
- NEVER let the early game become a "Waiting Simulator"; strictly **Front-Load Decisions** and quick early wins to build player momentum.
- NEVER modify a shared Resource directly; strictly use **`duplicate()`** to avoid unintentionally updating every building of that type.
- NEVER tie simulation logic to the visual framerate; strictly use **`_physics_process()`** or delta accumulators for deterministic simulation results.

### Performance & Threading
- NEVER update UI labels every frame; strictly use **Event-Driven Signals** to refresh UI ONLY when the underlying data changes.
- NEVER run heavy economic loops synchronously; strictly use **WorkerThreadPool** to offload complex calculations and prevent UI stutters.
- NEVER store massive resource data as Nodes; strictly use **`RefCounted`** or **Data Resources** to avoid the memory/CPU overhead of the SceneTree.
- NEVER ignore **`OS.low_processor_usage_mode`**; strictly enable it for stationary management screens to save massive CPU/Battery life.
- NEVER manipulate the SceneTree from background threads; strictly use **`call_deferred()`** for thread-safe UI updates.
- NEVER parse large JSON save files on the main thread; strictly use **Threaded Serialization** or optimized binary `.res` formats.
- NEVER use standard equality (==) for needs; strictly use **`is_equal_approx()`** to prevent floating-point jitter failures in logic gates.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [tycoon_economy.gd](../scripts/genre_simulation_tycoon_economy.gd) — integer cents / discrete stocks
> 2. [sim_tick_manager.gd](../scripts/genre_simulation_sim_tick_manager.gd) — `_physics_process` tick accumulator
> 3. [simulation_tick_controller.gd](../scripts/genre_simulation_simulation_tick_controller.gd) — speed / pause control surface

### Original Expert Patterns
- [tycoon_economy.gd](../scripts/genre_simulation_tycoon_economy.gd) - Multi-resource economy with **integer** currency (cents).
- [sim_tick_manager.gd](../scripts/genre_simulation_sim_tick_manager.gd) - Framerate-decoupled game-hour ticks on physics.

### Modular Components
- [simulation_tick_controller.gd](../scripts/genre_simulation_simulation_tick_controller.gd) - UI/speed wiring for the tick manager.
- [economy_graph_manager.gd](../scripts/genre_simulation_economy_graph_manager.gd) - Producer/consumer graph edges.
- [npc_schedule_agent.gd](../scripts/genre_simulation_npc_schedule_agent.gd) - Schedule-driven NPC agents on ticks.
- [simulation_patterns.gd](../scripts/genre_simulation_simulation_patterns.gd) - CSV→Resource bake, AStarGrid2D logistics, low_processor helpers.

---

## Core Loop
1. **Place/build** → 2. **Tick economy** → 3. **Read income vs expense** → 4. **Unlock / expand** → 5. **Optimize logistics**

## Decision Trees

### Currency & time (must match NEVER)
| Need | Action |
|------|--------|
| Money / wallets | **MANDATORY** [tycoon_economy.gd](../scripts/genre_simulation_tycoon_economy.gd) — integer cents, never float primary |
| Sim clock | **MANDATORY** [sim_tick_manager.gd](../scripts/genre_simulation_sim_tick_manager.gd) — accumulator on `_physics_process` |
| Speed UI | [simulation_tick_controller.gd](../scripts/genre_simulation_simulation_tick_controller.gd) |

### Tick rate vs UI vs threads
| Entity / load | Strategy |
|---------------|----------|
| < ~200 entities | Tick signal → direct update; UI via `resource_changed` only |
| Hundreds of agents | Rotate pools per tick; [npc_schedule_agent.gd](../scripts/genre_simulation_npc_schedule_agent.gd) |
| Heavy graph / path logistics | Offload with WorkerThreadPool; `call_deferred` UI — see [simulation_patterns.gd](../scripts/genre_simulation_simulation_patterns.gd) / [economy_graph_manager.gd](../scripts/genre_simulation_economy_graph_manager.gd) |
| Stationary management screens | Enable `OS.low_processor_usage_mode` |

Do **not** re-inline TycoonEconomy / SimulationTime / Worker tutorials — load the scripts.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Data | `resources`, `godot-economy-system` | Stocks / sinks |
| 2. Time | tick manager | Deterministic hours |
| 3. Agents | schedules / nav | NPCs & logistics |
| 4. Perf | WorkerThreadPool | Heavy ticks |
| 5. Balance | `godot-monte-carlo-balancer` | Bankruptcy / growth bands |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Float money | Integer cents in tycoon_economy |
| `_process` sim step | Physics accumulator tick manager |
| UI every frame | Signal on resource_changed only |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Simulation clocks and economy ticks must accumulate with `delta` (or a dedicated tick), never frame-count assumptions.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit resource/tick changes so dashboards refresh only when wallets or hours actually change.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Recipes, facilities, and unlock tables belong as `.tres` Resources so designers retune chains without code edits.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` build costs, wages, and growth bases so balance sheets stay Inspector-driven.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist stocks, day/hour, unlocks, and facility graphs so long management sessions survive restarts.
- [Data paths](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — Keep large binary/JSON sim saves under `user://` across platforms.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Heavy production-graph and upkeep passes belong on `WorkerThreadPool`, not the main-thread UI loop.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — Marshaling sim results to Labels/`Tree` requires `call_deferred` / main-thread SceneTree rules.
- [WorkerThreadPool](https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html) — API for batching economy ticks without blocking manager screens.
- [OS](https://docs.godotengine.org/en/stable/classes/class_os.html) — Enable `OS.low_processor_usage_mode` on stationary management UIs to cut CPU/battery burn.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — Grid logistics and worker paths on factory floors without manually wiring AStar points.
- [Using NavigationServers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html) — Direct `NavigationServer3D.map_get_path` queries for schedule-driven NPCs without per-agent node overhead.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoloads, Resources, and scene structure before building tick managers and economy graphs.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Dictionaries, signals, `is_equal_approx`, and fixed-point-safe math for currency and needs.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Production recipes and unlock tables should be Resource-first `.tres` assets, not hard-coded Node trees.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Tick and `resource_changed` buses must drive UI without Labels mutating the simulation wallet.

#### Complements
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Soft-currency wallets, sinks, and transaction ledgers that compose with tycoon multi-resource stocks.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Versioned serialization for large world states, binary `store_var`, and threaded save/load.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer / grid pathing for worker jobs and schedule agents after the tick clock exists.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Entity batching, low-processor mode, and thread offload budgets for 1000+ sim entities.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — TimeManager / Economy autoloads that survive scene reloads need clear ownership rules.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Income/expense dashboards and facility lists are `Tree`/`VBoxContainer` layouts bound to throttled signals.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After cost curves, production yields, and CSV→`.tres` balance sheets exist, Monte Carlo career sims prove minutes-to-milestone and bankruptcy bands before shipping growth factors.
- [godot-genre-idle-clicker](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md) — Offline catch-up and prestige loops reuse tick + integer-currency patterns from management sims.
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — Build-order economies and worker logistics consume the same tick/graph and pathfinding primitives at combat scale.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
