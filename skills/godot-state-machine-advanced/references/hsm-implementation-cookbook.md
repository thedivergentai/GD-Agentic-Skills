# HSM implementation cookbook

> [!CAUTION]
> Do **not** paste inline `HierarchicalState` samples from pre-lattice baselines — they double-`exit()` on pop. Use MANDATORY scripts.

## State base contract

```gdscript
class_name State extends Node
var state_machine: Node

func enter(_msg: Dictionary = {}) -> void: pass
func exit() -> void: pass
func update(_delta: float) -> void: pass
func physics_update(_delta: float) -> void: pass
func handle_input(_event: InputEvent) -> void: pass
```

## Routing

| Need | Script |
|------|--------|
| Hierarchy | [hsm_hierarchical_base.gd](../scripts/hsm_hierarchical_base.gd) |
| Push/pop overlays | [hsm_pushdown_stack.gd](../scripts/hsm_pushdown_stack.gd) |
| Guards | [hsm_transition_guard.gd](../scripts/hsm_transition_guard.gd) |
| Context | [hsm_state_context.gd](../scripts/hsm_state_context.gd) |

## Best practices

1. One state per file (`class_name`).
2. Signal `state_changed` for audio/VFX syncers.
3. Every `push_state` needs a `pop_state` plan.

Pushdown resume: `enter({"is_resume": true})` — [hsm_reentry_aware_state.gd](../scripts/hsm_reentry_aware_state.gd).
