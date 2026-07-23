---
name: godot-turn-system
description: "Expert blueprint for turn-based combat with turn order, action points, phase management, and timeline systems for strategy/RPG games. Covers speed-based initiative, interrupts, and simultaneous turns. Use when implementing turn-based combat OR tactical systems. Keywords turn-based, initiative, action points, phase, round, turn order, combat."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Turn System

Turn order calculation, action points, phase management, and timeline systems define turn-based combat.

## NEVER Do (Expert Anti-Patterns)

### Order & Determinism
- NEVER recalculate turn order every action; strictly sort once per round or ONLY when a speed-relevant stat changes to prevent O(n log n) lag.
- NEVER use random tie-breaking for initiative; strictly use a secondary static attribute (Agility, ID, or persistent "luck") for **deterministic replays**.
- NEVER modify an active turn-order queue while iterating it; strictly iterate over a `duplicate()` or apply queue modifications after the loop.
- NEVER broadcast global turn state changes using immediate `call_group()`; strictly use **`call_group_flags(SceneTree.GROUP_CALL_DEFERRED, ...)`** to prevent frame spikes when notifying hundreds of units.
 
- NEVER rely on the Node hierarchy as the source of truth; strictly use a **Dictionary board state** for logical grid coordinates.

### Logic & Action Economy
- NEVER deduct Action Points (AP) before validation; strictly call `can_perform_action(cost)` before applying `current_ap -= cost` to prevent exploits.
- NEVER hardcode phase transitions (`if phase == 0`); strictly use an **enum + match** or a dedicated State Machine for Draw/Main/End phases.
- NEVER emit "Turn Ended" before internal cleanup; strictly reset AP and tick status effects **BEFORE** signaling the next turn.
- NEVER use exact floating-point equality (`==`) for AP checks; strictly use `>=` or `is_equal_approx()` for robust comparisons.

### Tactical Grid & UI
- NEVER use generic `AStar2D` for tile grids; strictly use **`AStarGrid2D`** for 10x faster pathfinding and native diagonal handling.
- NEVER forget to call **`update()`** on `AStarGrid2D` after changing obstacle states; if you toggle `set_point_solid()`, the grid MUST refresh before the next query.
- NEVER lock the main thread with `while` loops for input; strictly use the **await keyword** or signals to yield execution back to the Tree.
- NEVER handle turn decisions with `is_action_pressed()`; strictly use `is_action_just_pressed()` for discrete, frame-locked menu input.
- NEVER skip turn timeouts in networked games; strictly implement a **server-side timer** with a default "pass" action to prevent griefing. See **Networked Turn Timeout** golden path below.

---

## Decision Tree — Pick a Turn Model

| Need | Choose | **MANDATORY** script |
|------|--------|----------------------|
| Discrete rounds (chess / tactics / card phases) | Round + initiative queue + AP phases | [turn_system_patterns.gd](../scripts/turn_system_turn_system_patterns.gd) |
| Continuous gauges (FF-style ATB) | Per-actor gauge fill in `_process` | [active_time_battle.gd](../scripts/turn_system_active_time_battle.gd) |
| Timeline / CTB with interrupts & prediction | Event timeline + predictive UI | [timeline_turn_manager.gd](../scripts/turn_system_timeline_turn_manager.gd) |

> **Do NOT** invent a fourth model inline. Read the matching script before coding.

## Expert Components (scripts/)

- [turn_system_patterns.gd](../scripts/turn_system_turn_system_patterns.gd) — Match-based phase machines, UndoRedo, `AStarGrid2D` board helpers.
- [active_time_battle.gd](../scripts/turn_system_active_time_battle.gd) — ATB gauges, pause-on-ready, async action handoff.
- [timeline_turn_manager.gd](../scripts/turn_system_timeline_turn_manager.gd) — Timeline / CTB with interrupts and pre-visualization.

## TurnManager Autoload — Interface Contract Only

Keep the Autoload thin. **Do not** paste full queue math here — implement in the script chosen above.

```gdscript
# turn_manager.gd (AutoLoad) — contract only
extends Node
signal turn_started(combatant: Node)
signal turn_ended(combatant: Node)
signal round_ended
signal turn_timed_out(combatant: Node)  # multiplayer: server default-pass

func start_combat(participants: Array[Node]) -> void: pass
func end_turn() -> void: pass
func request_pass(combatant: Node) -> void: pass  # default action on timeout
```

## Networked Turn Timeout (Golden Path)

Referenced from NEVER: server owns the clock; clients never decide "pass."

1. On `turn_started`, server starts a one-shot `Timer` / `SceneTreeTimer` (authoritative).
2. On timeout: server calls `request_pass(current)` (or auto-end-turn), then emits `turn_timed_out`.
3. Clients only render the countdown; never mutate the turn queue locally.
4. Pair with [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) for host-auth RPC.

## Action Points (Contract)

```gdscript
func can_perform_action(cost: int) -> bool:
    return current_action_points >= cost

func perform_action(cost: int) -> bool:
    if not can_perform_action(cost):
        return false
    current_action_points -= cost
    return true
```

Phases: prefer `enum Phase { DRAW, MAIN, END }` + `match`, or route to [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md). Full ATB / timeline math lives in the MANDATORY scripts — do not duplicate Elite snippets here.


## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — When turn ticks belong in `_process` vs `_physics_process` vs pure event steps.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Turn-start / turn-end / unit-acted events without polling gauges.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Initiative/speed stats as Resources for sim and UI prediction.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — TurnManager ownership boundaries.
- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) — `await` sequencing for multi-phase turns.
- [Object](https://docs.godotengine.org/en/stable/classes/class_object.html) — Signal connect flags for turn bus listeners.
- [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html) — Pausing gameplay while menus resolve turn choices.
- [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) — Optional realtime turn clocks without busy loops.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Animating ATB gauges and turn handoff juice.
- [AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html) — Action animations that must finish before the next turn.
- [MultiplayerAPI](https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html) — Authoritative turn order in networked matches.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Deterministic turn replay / seed logs for balance labs.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Scene and Autoload placement for TurnManager.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Turn bus contracts (signals up, commands down).
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Speed/initiative Resources shared with combat/UI.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Lifecycle of a global turn orchestrator.

#### Complements
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Per-unit states nested under turn phases.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Actions resolved inside a granted turn.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Speed/AGI feeding ATB gauges.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Cooldowns measured in turns, not wall-clock only.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Gauge fill and handoff presentation.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Host-auth turn order and lockstep.

#### Downstream / consumers
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — ATB/turn hybrids in ARPG/JRPG-adjacent combat.
- [godot-genre-card-game](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md) — Card turns and priority windows.
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — Discrete orders in strategy loops.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate turn matrices for speed/action fairness.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for turn systems.
