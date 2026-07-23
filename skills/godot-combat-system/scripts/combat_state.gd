# combat_state.gd
class_name CombatState
extends Node

enum State { IDLE, ATTACKING, BLOCKING, DODGING, STUNNED }

var current_state: State = State.IDLE
var can_act: bool = true

func enter_attack_state() -> bool:
	if not can_act:
		return false
	current_state = State.ATTACKING
	can_act = false
	return true

func enter_block_state() -> void:
	current_state = State.BLOCKING

func enter_dodge_state() -> bool:
	if not can_act:
		return false
	current_state = State.DODGING
	can_act = false
	return true

func exit_state() -> void:
	current_state = State.IDLE
	can_act = true
