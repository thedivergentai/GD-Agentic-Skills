---
name: godot-state-machine-advanced
description: "Expert blueprint for hierarchical finite state machines (HSM) and pushdown automata for complex AI/character behaviors. Covers state stacks, sub-states, transition validation, and state context passing. Use when basic FSMs are insufficient OR implementing layered AI. Keywords state machine, HSM, hierarchical, pushdown automata, state stack, FSM, AI behavior."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Advanced State Machines

Hierarchical states, state stacks, and context passing define complex behavior management.

## Available Scripts

### [hsm_hierarchical_base.gd](scripts/hsm_hierarchical_base.gd)
Advanced HSM base delegator for propagating physics and input to sub-states.

### [hsm_pushdown_stack.gd](scripts/hsm_pushdown_stack.gd)
Professional Pushdown Automata for interruptive state (Pause/Menu) stacking.

### [hsm_state_context.gd](scripts/hsm_state_context.gd)
Decoupled context object pattern for passing persistent data between states.

### [hsm_transition_guard.gd](scripts/hsm_transition_guard.gd)
Expert transition validation logic to prevent illegal state changes.

### [hsm_animation_syncer.gd](scripts/hsm_animation_syncer.gd)
Automated Logic-to-AnimationTree syncing with state-based travel logic.

### [hsm_concurrent_logic.gd](scripts/hsm_concurrent_logic.gd)
Orchestration for parallel state machines (e.g., Move + Attack).

### [hsm_resource_state_loader.gd](scripts/hsm_resource_state_loader.gd)
Data-driven state definition using custom Godot Resources (`.tres`).

### [hsm_reentry_aware_state.gd](scripts/hsm_reentry_aware_state.gd)
Handling resume-from-stack logic vs fresh entry events.

### [hsm_state_history_logger.gd](scripts/hsm_state_history_logger.gd)
Debug ring-buffer for tracking state transition history and stack depth.

### [hsm_state_timer_component.gd](scripts/hsm_state_timer_component.gd)
Auto-transition component for finite states like Stun or Dash.

> **MANDATORY**: For hierarchy / pushdown / guards read [hsm_hierarchical_base.gd](scripts/hsm_hierarchical_base.gd), [hsm_pushdown_stack.gd](scripts/hsm_pushdown_stack.gd), [hsm_transition_guard.gd](scripts/hsm_transition_guard.gd) (plus [hsm_logic_state.gd](scripts/hsm_logic_state.gd) for leaf behaviors).

## Decision Tree — Which Machine?

| Need | Choose | **MANDATORY** scripts |
|------|--------|------------------------|
| Few exclusive states, no nesting | Flat FSM | [hsm_logic_state.gd](scripts/hsm_logic_state.gd) + thin parent |
| Nested sub-states (Move/Air/Attack children) | HSM | [hsm_hierarchical_base.gd](scripts/hsm_hierarchical_base.gd) |
| Interrupt overlays (stun/menu/dialogue) then resume | Pushdown | [hsm_pushdown_stack.gd](scripts/hsm_pushdown_stack.gd) + [hsm_reentry_aware_state.gd](scripts/hsm_reentry_aware_state.gd) |
| Parallel concerns (locomotion + weapon) | Concurrent | [hsm_concurrent_logic.gd](scripts/hsm_concurrent_logic.gd) |
| Pick best action by score each tick | Utility cost polling | Expert pattern §3 + [hsm_transition_guard.gd](scripts/hsm_transition_guard.gd) |

## NEVER Do (Expert State Rules)

### Hierarchy & Delegation
- **NEVER forget to propagate physics/input to children** — In an HSM, failing to call `child.physics_update()` from the parent's `_physics_process` orphans child logic.
- **NEVER use deep nesting (>3 levels)** — Extreme hierarchy creates "State Spaghetti." If logic is that complex, consider a Behavior Tree or Utility AI.

### Transitions & Lifecycle
- **NEVER call enter() without a preceding exit()** — Skipping exit logic leaves timers, tweens, or audio loops running in the background, causing resource leaks.
- **NEVER modify state during a transition frame** — Re-entrant `transition_to()` calls inside `enter()` cause recursion crashes. Use `call_deferred` if immediate sub-transitioning is required.
- **NEVER hardcode state names as strings** — Typos like `transition_to("Idel")` are silent killers. Use `class_name` based checks OR Constants.

### Architecture & Context
- **NEVER use global singletons for state data** — Coupling states to `GameManager.player_health` makes them non-reusable. Pass a `Context` object.
- **NEVER push states indefinitely** — In a Pushdown Automaton, every `push_state` MUST have a retirement plan (`pop_state`) to avoid stack overflow.
- **NEVER assume state re-entry is always a fresh start** — Resuming from a stack pop should often bypass "Entry SFX/VFX"; use re-entry flags.

## Implementation — Scripts Are Source of Truth

> **Do NOT** copy inline HierarchicalState / push_state samples. Prior body double-`exit()`ed and ignored resume messages.

**MANDATORY route:**
- Hierarchy / physics-input forward: [hsm_hierarchical_base.gd](scripts/hsm_hierarchical_base.gd)
- Push / pop with `enter({"is_resume": true})`: [hsm_pushdown_stack.gd](scripts/hsm_pushdown_stack.gd)
- Illegal transition blocking: [hsm_transition_guard.gd](scripts/hsm_transition_guard.gd)
- Context payload: [hsm_state_context.gd](scripts/hsm_state_context.gd)

Pushdown contract (from script — single exit, resume msg):

```gdscript
# See hsm_pushdown_stack.gd — do not reimplement
func push_state(state_path: String, msg: Dictionary = {}) -> void: ...
func pop_state() -> void:
    # old.exit(); stack.back().enter({"is_resume": true})
    pass
```

## Expert State Machine Patterns

### 1. HSM Visualizer (Debug Tool)
Use a specialized `Control` node with `_draw()` to visualize the current state stack/hierarchy in the viewport for immediate debugging [3, 11].

```gdscript
class_name HSMVisualizer extends Control
@export var state_machine: Node

func _draw() -> void:
    var font := ThemeDB.fallback_font
    var pos := Vector2(20, 20)
    # Recursively draw active state names...
    draw_string(font, pos, "Active: " + state_machine.current_state.name)
```

### 2. State-Based Audio (Decoupled)
Avoid hardcoding `audio.play()` inside state `enter()` methods. Use a syncer that listens to `state_changed` and maps state names to `AudioStream` resources [12, 13].

```gdscript
class_name StateAudioSyncer extends Node
@export var state_machine: Node
@export var audio_map: Dictionary # { "Jump": preload("jump.wav") }

func _ready() -> void:
    state_machine.state_changed.connect(_on_state_changed)

func _on_state_changed(_old, new_state: Node):
    if audio_map.has(new_state.name):
        $AudioPlayer.stream = audio_map[new_state.name]
        $AudioPlayer.play()
```

### 3. Transition Cost (Utility AI)
Enable states to evaluate their own "weight" based on context. The StateMachine polls sibling costs and transitions to the lowest-cost behavior [17, 18].

```gdscript
# CostState.gd (Base)
func get_cost(context: Dictionary) -> float:
    return 10.0 # Default weight

# UtilityStateMachine.gd
func _physics_process(_d: float) -> void:
    var best_state: Node = current_state
    var low_cost: float = INF
    for child in get_children():
        var cost = child.get_cost(context)
        if cost < low_cost:
            low_cost = cost
            best_state = child
    if best_state != current_state:
        transition_to(best_state.name)
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Drive `state_changed` / transition fan-out so listeners (anim, audio, AI) stay decoupled from enter/exit bodies.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Child-node state ownership and signal-up / call-down so the machine orchestrates without sibling hard-coupling.
- [What are Godot classes](https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html) — Prefer composed state nodes + `class_name` over deep inheritance trees for layered AI behaviors.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Why HSMs must forward `_physics_process` / `_process` into the active child (or hierarchy) every tick.
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — `call_deferred` transitions avoid re-entrant `transition_to()` crashes inside `enter()`.
- [Godot notifications](https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html) — Safe wiring timing for initial `enter()` relative to `_ready` and parent caches.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Data-driven state definitions (`.tres`) for modular AI without baking scripts into every actor.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — Logic-to-AnimationTree travel when gameplay HSM states map to blend/state-machine graphs.
- [AnimationNodeStateMachinePlayback](https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html) — `travel()` / `start()` APIs used by animation syncers tied to HSM state names.
- [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) — Child lookup, process modes, and lifecycle hooks state nodes inherit as scene-tree citizens.
- [InputEvent](https://docs.godotengine.org/en/stable/classes/class_inputevent.html) — Typed events parents forward into `handle_input` on the active state.
- [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) — Finite-duration states (stun, dash) via one-shot timers that emit transition signals.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Scene ownership and project layout conventions every HSM root and child state scene assumes.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — class_name, typed Dictionaries/payloads, and Callables needed for guards, deferred transitions, and context objects.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Signal-up transition events without circular graphs where states emit and also listen to themselves.

#### Complements
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Drop HSM / VSM as a StateComponent under a composition root instead of bloating the actor script.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Sense-layer sampling; states receive directions/actions via handle_input rather than polling globals.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Locomotion states call move_and_slide / velocity APIs on the actor passed through context.
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — Blend trees and AnimationNodeStateMachine graphs that HSM syncers travel into by state name.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Tunable state Resources (speeds, stun durations, AI weights) separate from runtime Node lifecycle.
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — Sprite / AnimationPlayer presentation when a lighter sync path than a full AnimationTree is enough.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hit-stun, attack windup, and death stacks are classic pushdown / HSM consumers on fighters.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Cast, channel, and cooldown phases map cleanly to guarded transitions and timed states.
- [godot-turn-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md) — Turn phases and interrupt stacks reuse pushdown / concurrent machine orchestration patterns.
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Cutscene and dialogue overlays push over gameplay states and must pop without losing context.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting architecture concern.
