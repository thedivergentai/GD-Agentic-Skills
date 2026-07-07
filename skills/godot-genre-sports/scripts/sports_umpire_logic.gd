extends Node
class_name SportsUmpireLogic

## Expert Sports Umpire (Godot 4.7).
## Manages game state and scoring using a State Machine and Area3D signals.

enum State { PRE_GAME, ACTIVE, POST_GOAL, GAME_OVER }
var current_state: State = State.PRE_GAME
var score: int = 0

func _on_goal_area_body_entered(body: Node3D) -> void:
	if current_state == State.ACTIVE and body is RigidBody3D:
		_process_goal()

func _process_goal() -> void:
	score += 1
	current_state = State.POST_GOAL
	# Expert Pattern: Use SceneTreeTimer for non-blocking delays
	await get_tree().create_timer(2.0).timeout
	current_state = State.ACTIVE

## [SKILL NOTICE]: Use 'Area3D' for spatial triggers (goals/bounds) 
## and an 'enum' State Machine to manage rule logic.
