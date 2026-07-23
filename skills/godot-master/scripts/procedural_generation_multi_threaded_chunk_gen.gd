# multi_threaded_chunk_gen.gd
# Offloading heavy proc-gen tasks to WorkerThreadPool
extends Node

signal chunk_ready(chunk_pos: Vector2i, height_data: PackedFloat32Array)

@export var world_seed: int = 0
@export var chunk_size: int = 16

var _noise := FastNoiseLite.new()

func _ready() -> void:
	_noise.seed = world_seed
	_noise.frequency = 0.05
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN

func request_chunk(chunk_pos: Vector2i) -> void:
	WorkerThreadPool.add_task(_generate_chunk_task.bind(chunk_pos))

func _generate_chunk_task(pos: Vector2i) -> void:
	var data := _calc_data(pos)
	call_deferred("_finalize_chunk", pos, data)

func _calc_data(pos: Vector2i) -> PackedFloat32Array:
	var data := PackedFloat32Array()
	data.resize(chunk_size * chunk_size)
	for y in chunk_size:
		for x in chunk_size:
			var wx := pos.x * chunk_size + x
			var wy := pos.y * chunk_size + y
			data[y * chunk_size + x] = _noise.get_noise_2d(float(wx), float(wy))
	return data

func _finalize_chunk(pos: Vector2i, data: PackedFloat32Array) -> void:
	chunk_ready.emit(pos, data)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md — chunk request radii around the player
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — main-thread scene attach after deferred finalize
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
