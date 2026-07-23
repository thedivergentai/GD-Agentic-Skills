extends Node3D
class_name LODLogicEnabler

## Expert LOD Logic (Godot 4.7).
## Performance-first logic throttling based on distance.

@export var ai_node: Node3D
@export var player: Node3D
@export var disable_dist_sq: float = 6400.0 # 80 meters squared

func _ready() -> void:
	# Optimization: Use a slow timer for distance checks
	var t = Timer.new()
	t.wait_time = 0.5
	t.timeout.connect(_check_distance)
	add_child(t)
	t.start()

func _check_distance() -> void:
	if not player or not ai_node: return
	var d2 = global_position.distance_squared_to(player.global_position)
	
	if d2 > disable_dist_sq:
		ai_node.process_mode = PROCESS_MODE_DISABLED
	else:
		ai_node.process_mode = PROCESS_MODE_INHERIT

## [SKILL NOTICE]: Use 'distance_squared_to' for LOD checks. 
## It skips expensive square-root math, vital for 1000s of entities.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — PROCESS_MODE_DISABLED for far AI/logic
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — disable path agents outside active radius
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
