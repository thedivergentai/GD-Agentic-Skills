---
name: godot-signal-architecture
description: "Expert blueprint for signal-driven architecture using \"Signal Up, Call Down\" pattern for loose coupling. Covers typed signals, signal chains, one-shot connections, and AutoLoad event buses. Use when implementing event systems OR decoupling nodes. Keywords signal, emit, connect, CONNECT_ONE_SHOT, CONNECT_REFERENCE_COUNTED, event bus, AutoLoad, decoupling."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Signal Architecture

Signal Up/Call Down, typed signals, and scoped buses — not connect/emit tutorials.

## NEVER Do in Signal Architecture

- **NEVER use the legacy string-based `Object.connect()`** — Typos result in silent failures. Always use `signal.connect(_callback)` for compile-time validation.
- **NEVER use signals to dictate behavior top-down** — Signals are past-tense events (e.g., "died"). Use direct method calls for commands (e.g., "kill").
- **NEVER connect a signal twice to the same Callable** — This throws an `ERR_INVALID_PARAMETER` at runtime unless using the `Object.CONNECT_REFERENCE_COUNTED` flag to stack connections.
- **NEVER use a Global Signal Bus for local data** — Pollutes global state and makes debugging harder. Use local connections for scene-specific logic.
- **NEVER assume callbacks must accept all signal arguments** — Use `unbind()` to drop unwanted parameters and keep your API clean.
- **NEVER create circular signal dependencies** — A signals B, B signals back to A? Use a mediator (parent or AutoLoad) to break the loop.
- **NEVER skip signal typing** — `signal moved` without types lacks editor support. Always use `signal moved(dir: Vector2)`.
- **NEVER forget to disconnect dynamic signals** — Ghost connections cause "call on null instance" errors. Disconnect in `_exit_tree()` or when retargeting ([disconnect_ghost_signals.gd](../scripts/signal_architecture_disconnect_ghost_signals.gd)).
- **NEVER emit signals with immediate side effects on the emitter** — If `died.emit()` calls `queue_free()`, listeners might fail to respond. Emit first.
- **NEVER use signals for high-frequency data streams** — Sending 1000+ signals/second (like per-particle updates) is inefficient. Use shared arrays or direct buffers.

---

## Signal Up / Call Down

- **Children → parents:** past-tense signals (`health_changed`, `died`).
- **Parents → children:** direct calls / properties (`apply_damage`, `play_anim`).
- **Siblings:** parent mediator or carefully scoped Autoload bus — never sibling hard refs.

**Use signals for:** UI presses, death → game over, loot → inventory, cross-scene bus events.
**Use direct calls for:** parent commanding child, local property access.

## Decision Tree: Where to Connect

| Scope | Pattern | MANDATORY script |
|-------|---------|------------------|
| Child notifies parent / UI | Local `signal.connect` in parent `_ready` | [signal_up_call_down_pattern.gd](../scripts/signal_architecture_signal_up_call_down_pattern.gd) |
| Parent orchestrates children | Method calls down (not signals) | same |
| Cross-scene / systems (achievements, save) | Autoload bus | [global_signal_bus_router.gd](../scripts/signal_architecture_global_signal_bus_router.gd) / [global_event_bus.gd](../scripts/signal_architecture_global_event_bus.gd) |
| Linear async steps (load → fade → spawn) | `await` signal sequence | [await_signal_sequencing.gd](../scripts/signal_architecture_await_signal_sequencing.gd) / [complex_signal_sequencer.gd](../scripts/signal_architecture_complex_signal_sequencer.gd) |
| Retarget tracking (new enemy) | Disconnect old first | [disconnect_ghost_signals.gd](../scripts/signal_architecture_disconnect_ghost_signals.gd) |
| One-shot / physics-safe | `CONNECT_ONE_SHOT` / `CONNECT_DEFERRED` | [one_shot_deferred_connections.gd](../scripts/signal_architecture_one_shot_deferred_connections.gd) |
| Extra context / drop args | `Callable.bind` / `unbind` | [callable_bind_context.gd](../scripts/signal_architecture_callable_bind_context.gd) / [unbind_unwanted_args.gd](../scripts/signal_architecture_unbind_unwanted_args.gd) |

## Available Scripts

- [signal_up_call_down_pattern.gd](../scripts/signal_architecture_signal_up_call_down_pattern.gd) — **MANDATORY** before hierarchy wiring.
- [global_signal_bus_router.gd](../scripts/signal_architecture_global_signal_bus_router.gd) / [global_event_bus.gd](../scripts/signal_architecture_global_event_bus.gd) — **MANDATORY** before Autoload buses.
- [disconnect_ghost_signals.gd](../scripts/signal_architecture_disconnect_ghost_signals.gd) — **MANDATORY** when switching tracked emitters.
- [await_signal_sequencing.gd](../scripts/signal_architecture_await_signal_sequencing.gd) / [complex_signal_sequencer.gd](../scripts/signal_architecture_complex_signal_sequencer.gd) — **MANDATORY** for multi-step awaits.
- [safe_dynamic_connections.gd](../scripts/signal_architecture_safe_dynamic_connections.gd) — `is_connected` guards.
- [one_shot_deferred_connections.gd](../scripts/signal_architecture_one_shot_deferred_connections.gd) — one-shot / deferred flags.
- [callable_bind_context.gd](../scripts/signal_architecture_callable_bind_context.gd) / [unbind_unwanted_args.gd](../scripts/signal_architecture_unbind_unwanted_args.gd) — bind/unbind.
- [track_signal_emitter_source.gd](../scripts/signal_architecture_track_signal_emitter_source.gd) — `CONNECT_APPEND_SOURCE_OBJECT`.
- [signal_debugger.gd](../scripts/signal_architecture_signal_debugger.gd) / [signal_spy.gd](../scripts/signal_architecture_signal_spy.gd) — debug / test spies.

## Lambda Capture Cleanup (complete)

Godot auto-disconnects most connections when a node frees. **Exception:** lambdas that capture locals — you must disconnect manually.

```gdscript
var my_lambda: Callable

func _ready() -> void:
    var x := 10
    my_lambda = func(): print(x)
    player.died.connect(my_lambda)

func _exit_tree() -> void:
    if player and player.died.is_connected(my_lambda):
        player.died.disconnect(my_lambda)
```

Prefer named methods or [disconnect_ghost_signals.gd](../scripts/signal_architecture_disconnect_ghost_signals.gd) when retargeting.

## CONNECT_REFERENCE_COUNTED — Correct Semantics

`CONNECT_REFERENCE_COUNTED` means **multiple identical connects share one connection with a refcount** (connect N times / disconnect N times). It is **not** "auto-cleanup when the emitter frees" and does **not** fix capturing-lambda leaks.

- Auto-cleanup on free: normal connections to Object methods (non-capturing) are cleared when either side is freed.
- Capturing lambdas: always manual `disconnect` (see above).
- One-shot auto-remove after fire: `CONNECT_ONE_SHOT`.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Core emit/connect model and why signals decouple nodes without hard references.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Canonical “signal up, call down” ownership rules that keep parent→child command flows explicit.
- [Instancing with signals](https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html) — Emit from spawned scenes so parents/managers receive bullets, loot, and other products without fixed node paths.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — When a global EventBus is justified vs when scene-local signal wiring is safer.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — How to register a typed signal bus that survives scene changes.
- [Signal](https://docs.godotengine.org/en/stable/classes/class_signal.html) — Typed `Signal` API: `emit`, `connect`, `is_connected`, and disconnect helpers used throughout this skill.
- [Callable](https://docs.godotengine.org/en/stable/classes/class_callable.html) — `bind()` / `unbind()` for injecting or discarding callback context without wrapper lambdas.
- [Object](https://docs.godotengine.org/en/stable/classes/class_object.html) — `CONNECT_ONE_SHOT`, `CONNECT_DEFERRED`, `CONNECT_REFERENCE_COUNTED`, and `CONNECT_APPEND_SOURCE_OBJECT` flags.
- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) — Typed `signal` declarations and `await` on signals for linear async sequences.
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — Connection lifetime across enter/exit tree and why dynamic listeners must disconnect when retargeting.
- [Godot notifications](https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html) — Safe connection timing relative to `_ready`, parent caches, and user signals.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Why deferred signal handlers matter when callbacks mutate physics bodies mid-step.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, Autoload registration, and scene ownership conventions signals plug into.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Callables, `await`, and signal syntax required before advanced connect flags and sequencers.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton boot order and ownership rules for global EventBus routers (not for local scene events).

#### Complements
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Component nodes emit past-tense events; parents compose by connecting those signals and calling down.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Scene swaps and loaders must reconnect or re-emit through buses without ghost listeners.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — State enter/exit often drives signal fan-out; keeps FSM transitions from becoming circular signal graphs.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Prefer Resources for shared config; signals carry change events, not duplicated mutable state blobs.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — `watch_signals` / spies pair with this skill’s emit contracts for unit and integration tests.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Buttons and menus should signal intent upward; controllers call down to update Control trees.

#### Downstream / consumers
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Line/choice completion events should follow signal-up orchestration into UI and quest listeners.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Cooldown, cast, and hit payloads need typed signals so HUD/VFX stay decoupled from ability nodes.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage/death/score chains are the classic signal-up fan-out into UI, audio, and progression.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when high-frequency emit storms show up; replace per-tick signals with buffers or direct reads.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting architecture concern.
