---
name: godot-genre-idle-clicker
description: "Expert blueprint for idle/clicker games including big number handling (mantissa + exponent system), exponential growth curves (cost_growth_factor 1.15x), generator systems (auto-producers), offline progress calculation, prestige systems (reset for permanent multipliers), number formatting (K/M/B suffixes, scientific notation). Use for incremental games, idle games, or cookie clicker derivatives. Trigger keywords: idle_game, big_number, exponential_growth, generator_system, offline_progress, prestige_system, number_formatting."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Idle / Clicker

Expert blueprint for idle/clicker games with exponential progression and prestige mechanics.

## NEVER Do (Expert Anti-Patterns)

### Economics & Math
- NEVER use standard floats for currency; strictly implement a **BigNumber** (Mantissa/Exponent) system (e.g., `1.5e300`) to prevent `INF` crashes at 1e308.
- NEVER use `Timer` nodes for revenue generation; strictly use a manual accumulator in `_process(delta)` to prevent drift during frame fluctuations.
- NEVER hardcode generator costs or growth; strictly use an exponential formula: `Cost = BasePrice * pow(GrowthFactor, OwnedCount)` (industry standard **1.15x**).
- NEVER evaluate exact float equality (`==`); strictly use `is_equal_approx()` or `>=` to prevent "stuck" progress due to precision loss.
- NEVER parse scientific notation strings with `to_int()`; strictly use `to_float()` or a dedicated BigNumber parser.

### Performance & Optimization
- NEVER update all UI labels every frame; strictly use **Signals** to update labels ONLY when values change, or throttle updates to 10 FPS.
- NEVER ignore **Low Processor Usage Mode** for mobile; strictly enable `OS.low_processor_usage_mode = true` to preserve battery life.
- NEVER instantiate/delete hundreds of text nodes per second; strictly use **Object Pooling** or `MultiMeshInstance` for click-feedback.
- NEVER update massive logs by modifying the `text` property; strictly use `append_text()` to prevent main thread blocking.

### Player Experience & Persistence
- NEVER ignore **Offline Progress**; strictly calculate `seconds_offline * total_revenue` using system UNIX timestamps (`Time.get_unix_time_from_system()`).
- NEVER make the "Prestige" reset feel like a loss; strictly provide a global multiplier that makes the next run **significantly** faster (2-5x).
- NEVER calculate offline time using `Time.get_ticks_msec()`; strictly use **Persistent UNIX timestamps** as ticks reset on app restart.
- NEVER use Node hierarchies for raw data; strictly use `RefCounted` or `Resource` objects for lightweight, serializable logic.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [big_number.gd](scripts/big_number.gd) — mantissa + exponent beyond float INF
> 2. [generator.gd](scripts/generator.gd) — exponential cost / rate units
> 3. [scientific_notation_formatter.gd](scripts/scientific_notation_formatter.gd) — K/M/B/T + scientific display
> 4. [offline_progress_calculator.gd](scripts/offline_progress_calculator.gd) — UNIX offline catch-up (not `ticks_msec`)

### Original Expert Patterns
- [big_number.gd](scripts/big_number.gd) - Mantissa + Exponent math for e308+ scales.
- [generator.gd](scripts/generator.gd) - Exponential cost units and production rate calculation.
- [scientific_notation_formatter.gd](scripts/scientific_notation_formatter.gd) - Readable K/M/B/T and scientific suffixes.

### Modular Components
- [offline_progress_calculator.gd](scripts/offline_progress_calculator.gd) - Real-world delta tracking using UNIX timestamps.
- [functional_income_reducer.gd](scripts/functional_income_reducer.gd) - Fast income summation patterns.
- [threaded_catchup_simulator.gd](scripts/threaded_catchup_simulator.gd) - WorkerThreadPool background catch-up.
- [precision_cost_validator.gd](scripts/precision_cost_validator.gd) - Cost curve / affordability checks.
- [scientific_notation_math.gd](scripts/scientific_notation_math.gd) - Shared mantissa helpers for formatters.
- [idle_performance_setup.gd](scripts/idle_performance_setup.gd) - `low_processor_usage_mode` + signal-throttled UI.
- [decoupled_economy_signal_bus.gd](scripts/decoupled_economy_signal_bus.gd) - Throttled economy→UI signals.
- [lightweight_upgrade_resource.gd](scripts/lightweight_upgrade_resource.gd) - Upgrade `.tres` pattern.
- [big_int_save_parser.gd](scripts/big_int_save_parser.gd) - Persist big numbers safely.
- [thread_safe_ui_updater.gd](scripts/thread_safe_ui_updater.gd) - Deferred UI after threaded catch-up.

---

## Core Loop
1. **Click** → 2. **Buy generators** → 3. **Idle income** → 4. **Upgrade** → 5. **Prestige**

## Decision Trees

### Numbers & display
| Need | Action |
|------|--------|
| Values past ~1e308 | **MANDATORY** [big_number.gd](scripts/big_number.gd) |
| Labels / abbreviations | **MANDATORY** [scientific_notation_formatter.gd](scripts/scientific_notation_formatter.gd) |
| Cost curve ~1.15^n | [generator.gd](scripts/generator.gd) + [precision_cost_validator.gd](scripts/precision_cost_validator.gd) |

### Offline & perf
| Need | Action |
|------|--------|
| Offline catch-up | **MANDATORY** [offline_progress_calculator.gd](scripts/offline_progress_calculator.gd) (UNIX time) |
| Long catch-up | [threaded_catchup_simulator.gd](scripts/threaded_catchup_simulator.gd) |
| Battery / idle CPU | [idle_performance_setup.gd](scripts/idle_performance_setup.gd) |

Do **not** re-inline BigNumber/Offline tutorials in the skill body — load the scripts above.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Math | `godot-gdscript-mastery` | Big-number arithmetic |
| 2. UI | `godot-ui-containers`, `labels` | Scientific / suffix labels |
| 3. Data | `godot-save-load-systems` | Offline timestamps + prestige |
| 4. Logic | `signals` | Throttled economy UI |
| 5. Balance | `godot-monte-carlo-balancer` | Minutes-to-milestone bands |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Wrong Expert Component hrefs | Links above point at canonical `big_number` / `generator` / formatter |
| `Time.get_ticks_msec` offline | Use UNIX via offline calculator |
| UI every frame | Signal-throttle via economy bus / performance setup |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Revenue must accumulate in `_process(delta)` (or a fixed sim tick), not drifting `Timer` nodes, so generators stay frame-rate independent.
- [Time](https://docs.godotengine.org/en/stable/classes/class_time.html) — Offline catch-up uses `Time.get_unix_time_from_system()`; never `get_ticks_msec()`, which resets when the app restarts.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist currency, generator counts, prestige multipliers, and last-save UNIX timestamps so welcome-back earnings survive restarts.
- [Data paths](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — Keep save blobs under `user://` so offline timestamps and big-number strings remain writable across platforms.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Generators, upgrades, and prestige curves belong as `.tres` Resources so designers retune `cost_growth_factor` without code changes.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` base costs, revenue rates, and growth factors so balance sheets stay Inspector-driven.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `currency_updated` only when balances change so HUD labels do not rewrite every frame.
- [OS](https://docs.godotengine.org/en/stable/classes/class_os.html) — Enable `OS.low_processor_usage_mode` (and sleep usec) for mobile idle sessions that spend most time waiting on generators.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Long offline catch-up sims belong on `WorkerThreadPool`; UI must not block while thousands of ticks replay.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — Marshaling sim results to Labels requires `call_deferred` / main-thread rules from this page.
- [Formatting strings](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html) — K/M/B suffixes and `%.2fe%d` scientific display depend on correct format strings (and `String.num_scientific` when appropriate).
- [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html) — BigNumber and upgrade payloads should be lightweight `RefCounted`/`Resource` data, not Node trees.

### Related Skills

#### Prerequisites
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Mantissa/exponent classes, `pow` growth, and precision-safe compares (`is_equal_approx`) are core GDScript patterns before building idle economies.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Generator and upgrade definitions should be Resource-first so balance curves stay data-driven `.tres` assets.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Decoupled currency buses must signal up to UI and never let Labels mutate the simulation wallet.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Offline progress and prestige state need versioned save handlers that store UNIX timestamps and big-number strings safely.

#### Complements
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Soft-currency wallets, sinks, and transaction APIs compose with idle generators when the game grows shops or prestige shops.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Generator lists and upgrade grids are `GridContainer`/`VBoxContainer` layouts bound to throttle-friendly labels.
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — Scientific notation, suffix strings, and append-only logs belong in Label/RichTextLabel patterns rather than rebuilding huge `text` blobs.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Low-processor mode, UI throttling, and pooled click-juice keep idle loops battery-friendly on mobile.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Simulation managers and economy buses that survive scene reloads should follow Autoload ownership rules.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Click-feedback bursts should use batched `GPUParticles2D.emit_particle` rather than spawning Label nodes per tap.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After cost curves and prestige multipliers are Resource-driven, Monte Carlo career sims prove minutes-to-milestone bands (not win%) before shipping growth factors.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Shipping idle on phones consumes low-processor mode, background resume, and offline catch-up patterns from this genre skill.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
