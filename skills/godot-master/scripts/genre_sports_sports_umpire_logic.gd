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

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — PRE_GAME/ACTIVE/POST_GOAL match phases
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — goal Area3D body_entered event wiring
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sports/SKILL.md
# =============================================================================
