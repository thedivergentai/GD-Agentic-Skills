extends CharacterBody3D
class_name CrowdNavigationUnit

## Expert Crowd Pathfinding (Godot 4.7).
## Optimized RVO avoidance with arrival dampening.

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	nav_agent.avoidance_enabled = true
	# Expert Pattern: Increase distance to prevent "dancing" at target
	nav_agent.target_desired_distance = 1.5
	nav_agent.velocity_computed.connect(_move_unit)

func set_move_target(target: Vector3) -> void:
	nav_agent.target_position = target

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished(): return
	
	var next_path_pos = nav_agent.get_next_path_position()
	var new_vel = global_position.direction_to(next_path_pos) * 5.0
	# Send preferred velocity to NavigationServer for RVO processing
	nav_agent.set_velocity(new_vel)

func _move_unit(safe_vel: Vector3) -> void:
	velocity = safe_vel
	move_and_slide()

## [SKILL NOTICE]: Set 'target_desired_distance' > 1.0 for crowds. 
## This prevents units from oscillating indefinitely when they reach a dense target.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — avoidance + arrival dampening
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — crowd agent budgets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
