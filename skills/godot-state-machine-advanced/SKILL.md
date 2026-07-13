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

> **MANDATORY**: Read hsm_logic_state.gd before implementing hierarchical AI behaviors.


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

---

```gdscript
# hierarchical_state.gd
class_name HierarchicalState
extends Node

signal transitioned(from_state: String, to_state: String)

var current_state: Node
var state_stack: Array[Node] = []

func  _ready() -> void:
    for child in get_children():
        child.state_machine = self
    
    if get_child_count() > 0:
        current_state = get_child(0)
        current_state.enter()

func transition_to(state_name: String) -> void:
    if not has_node(state_name):
        return
    
    var new_state := get_node(state_name)
    
    if current_state:
        current_state.exit()
    
    transitioned.emit(current_state.name if current_state else "", state_name)
    current_state = new_state
    current_state.enter()

func push_state(state_name: String) -> void:
    if current_state:
        state_stack.append(current_state)
        current_state.exit()
    
    transition_to(state_name)

func pop_state() -> void:
    if state_stack.is_empty():
        return
    
    var previous_state := state_stack.pop_back()
    transition_to(previous_state.name)
```

## State Base Class

```gdscript
# state.gd
class_name State
extends Node

var state_machine: HierarchicalState

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass

func handle_input(event: InputEvent) -> void:
    pass
```

## Best Practices

1. **Separation** - One state per file
2. **Signals** - Communicate state changes
3. **Stack** - Use push/pop for interruptions

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
- Related: `godot-characterbody-2d`, `godot-animation-player`


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
