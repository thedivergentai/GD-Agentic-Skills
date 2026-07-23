# runtime_tree_debugging.gd
# Runtime tool for visualizing and logging current AnimTree states
extends AnimationTree

@export var debug_interval: float = 1.0
var _timer: float = 0.0

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= debug_interval:
		_timer = 0.0
		_log_state()

func _log_state() -> void:
	var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")
	if not playback: return
	
	var current = playback.get_current_node()
	var travel = playback.get_travel_path()
	
	print("[AnimTree Debug] Current: %s | Queue: %s" % [current, travel])
	
	# Check specific blend values
	var movement_pos = get("parameters/Movement/blend_position")
	print("  - Movement Blend: ", movement_pos)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — structured runtime diagnostics
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — throttle debug logging off hot paths
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
