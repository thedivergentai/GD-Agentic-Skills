# wave_manager.gd
# [GDSKILLS] godot-game-loop-waves
# EXPORT_REFERENCE: wave_manager.gd

extends Node

signal wave_started(wave_index: int)
signal wave_cleared(wave_index: int)
signal all_waves_complete()
signal enemy_spawned(enemy: Node)

@export var wave_sequence: Array[WaveResource] = []
@export var auto_start: bool = false
## Optional Marker3D / WaveWeightedSpawner that supplies spawn positions.
@export var spawner: Node3D
## When true, reuse inactive pooled enemies instead of instantiate/free churn.
@export var use_pool: bool = false

var current_wave_index: int = -1
var active_count: int = 0
var pending_spawns: int = 0
var is_spawning: bool = false
var _pool: Array[Node] = []

func _ready() -> void:
	if auto_start:
		start_next_wave()

func start_next_wave() -> void:
	if current_wave_index + 1 >= wave_sequence.size():
		all_waves_complete.emit()
		return

	current_wave_index += 1
	var current_wave = wave_sequence[current_wave_index]

	if current_wave.pre_wave_delay > 0:
		await get_tree().create_timer(current_wave.pre_wave_delay).timeout

	_trigger_wave(current_wave)

func _trigger_wave(wave: WaveResource) -> void:
	is_spawning = true
	wave_started.emit(current_wave_index)

	var spawn_list: Array = []
	for scene in wave.compositions:
		var count = wave.compositions[scene]
		for i in range(count):
			spawn_list.append(scene)

	if wave.random_spawning:
		spawn_list.shuffle()

	for enemy_scene in spawn_list:
		_spawn_enemy(enemy_scene)
		await get_tree().create_timer(1.0 / wave.spawn_rate).timeout

	is_spawning = false
	_check_wave_clear()

func _spawn_enemy(scene: PackedScene) -> void:
	var enemy: Node
	if use_pool and not _pool.is_empty():
		enemy = _pool.pop_back()
		if enemy.has_method(&"reset_for_pool"):
			enemy.call(&"reset_for_pool")
		elif "visible" in enemy:
			enemy.visible = true
	else:
		enemy = scene.instantiate()

	enemy.add_to_group(&"enemies")
	if not enemy.tree_exited.is_connected(_on_enemy_tree_exited):
		enemy.tree_exited.connect(_on_enemy_tree_exited)

	# NEVER add_child synchronously from spawn loops / physics — defer.
	pending_spawns += 1
	call_deferred(&"_add_enemy", enemy)

func _add_enemy(enemy: Node) -> void:
	pending_spawns = maxi(pending_spawns - 1, 0)
	if not is_inside_tree():
		enemy.queue_free()
		_check_wave_clear()
		return
	if enemy.get_parent() != self:
		add_child(enemy)
	if spawner and enemy is Node3D:
		if spawner.has_method(&"get_spawn_position"):
			(enemy as Node3D).global_position = spawner.call(&"get_spawn_position")
		else:
			(enemy as Node3D).global_position = spawner.global_position
	active_count += 1
	enemy_spawned.emit(enemy)
	_check_wave_clear()

func _on_enemy_tree_exited() -> void:
	active_count = maxi(active_count - 1, 0)
	_check_wave_clear()

func _check_wave_clear() -> void:
	# Prefer signal/group counts over scanning children every frame.
	# Wait for deferred adds so we never clear mid-spawn.
	if is_spawning or pending_spawns > 0:
		return
	var group_count := get_tree().get_node_count_in_group(&"enemies")
	if group_count == 0 and active_count == 0:
		wave_cleared.emit(current_wave_index)
		start_next_wave()

func recycle_enemy(enemy: Node) -> void:
	if not use_pool:
		enemy.queue_free()
		return
	if enemy.is_inside_tree():
		remove_child(enemy)
	if enemy.is_in_group(&"enemies"):
		enemy.remove_from_group(&"enemies")
	if "visible" in enemy:
		enemy.visible = false
	_pool.append(enemy)
	active_count = maxi(active_count - 1, 0)
	_check_wave_clear()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — wave_started/cleared fan-out
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — death hooks that clear active enemies
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md
# =============================================================================
