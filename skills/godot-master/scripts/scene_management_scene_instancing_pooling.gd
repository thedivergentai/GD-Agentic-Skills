# scene_instancing_pooling.gd
# Object pooling for high-frequency scene instancing
extends Node

@export var scene_to_pool: PackedScene
@export var pool_size := 50

var _pool: Array = []

func _ready() -> void:
	for i in pool_size:
		var instance = scene_to_pool.instantiate()
		instance.visible = false
		instance.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(instance)
		_pool.append(instance)

func spawn(pos: Vector2):
	for i in _pool:
		if i.process_mode == Node.PROCESS_MODE_DISABLED:
			i.global_position = pos
			i.visible = true
			i.process_mode = Node.PROCESS_MODE_INHERIT
			return i
	return null # Pool exhausted
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/instancing.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — prewarm pools to avoid instantiate spikes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — pooled component scenes with process_mode disable/enable
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
