# low_level_avoidance.gd
# Direct RVO (Reciprocal Velocity Obstacles) registration bypassing nodes
extends Node3D

var agent_rid: RID

func _ready() -> void:
	agent_rid = NavigationServer3D.agent_create()
	NavigationServer3D.agent_set_map(agent_rid, get_world_3d().get_navigation_map())
	
	# Set agent avoidance properties
	NavigationServer3D.agent_set_avoidance_enabled(agent_rid, true)
	NavigationServer3D.agent_set_radius(agent_rid, 0.6)
	NavigationServer3D.agent_set_max_speed(agent_rid, 4.0)
	
	# Register the callback for safe velocity computation
	NavigationServer3D.agent_set_avoidance_callback(agent_rid, Callable(self, "_on_safe_velocity_computed"))

func _physics_process(delta: float) -> void:
	var desired_vel = calculate_desired_velocity()
	# Update server with intended velocity
	NavigationServer3D.agent_set_velocity(agent_rid, desired_vel)

func _on_safe_velocity_computed(safe_velocity: Vector3) -> void:
	# Apply computed safe velocity during physics tick
	# (e.g. move_and_slide())
	pass

func calculate_desired_velocity() -> Vector3:
	return Vector3.ZERO # Implementation specific
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md — server RVO for large unit counts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoidance callbacks without agent nodes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md
# =============================================================================
