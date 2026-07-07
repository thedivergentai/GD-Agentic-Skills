class_name GlobalGameState
extends Node

## Expert Global State Machine (Godot 4.7).
## Uses deferred transitions to prevent frame-locked race conditions.

signal state_changed(old_state: State, new_state: State)

enum State { MENU, LOADING, IN_GAME, PAUSED, GAME_OVER }

var current_state: State = State.MENU
var _is_transitioning: bool = false

func request_transition(new_state: State) -> void:
	if _is_transitioning or current_state == new_state:
		return
	
	_is_transitioning = true
	# Use call_deferred to ensure physics/logic have finished current frame
	call_deferred("_apply_transition", new_state)

func _apply_transition(new_state: State) -> void:
	var old := current_state
	current_state = new_state
	_is_transitioning = false
	state_changed.emit(old, current_state)

## [SKILL NOTICE]: NEVER change global state inside a physics callback 
## without deferring, or related systems may read stale/conflicting data.
