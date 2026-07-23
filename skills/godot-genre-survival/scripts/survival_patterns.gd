# survival_patterns.gd
extends Node
class_name SurvivalPatterns

## Executable survival expert patterns (not stub notes).

signal chunk_loaded(path: String, resource: Resource)
signal noise_chunk_ready(origin: Vector2i, heights: PackedFloat32Array)

# 1. Activity-scaled vital decay
func process_survival_vitals(hunger: float, thirst: float, delta: float, decay_rate: float, activity_mult: float = 1.0) -> Vector2:
	var scale := decay_rate * activity_mult * delta
	return Vector2(hunger - scale, thirst - scale * 1.5)

# 2. Environment Lighting Tween (Day/Night)
func transition_to_night(env: Environment, duration: float = 10.0) -> Tween:
	var tween := create_tween()
	tween.tween_property(env, "ambient_light_energy", 0.1, duration)
	return tween

# 3. MultiMeshInstance for Optimized Forests/Nature
func populate_nature(mm: MultiMesh, transforms: Array[Transform3D]) -> void:
	mm.instance_count = transforms.size()
	for i in transforms.size():
		mm.set_instance_transform(i, transforms[i])

# 4. Deep Duplication of Item Resources
func initialize_item_stats(base_stats: Resource) -> Resource:
	return base_stats.duplicate(true)

# 5. Asynchronous World Chunk Loading
func load_world_chunk(path: String) -> void:
	ResourceLoader.load_threaded_request(path)
	_poll_chunk.call_deferred(path)

func _poll_chunk(path: String) -> void:
	var status := ResourceLoader.load_threaded_get_status(path)
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		_poll_chunk(path)
		return
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		chunk_loaded.emit(path, ResourceLoader.load_threaded_get(path))

# 11. WorkerThreadPool noise chunk (off main thread — aligns with NEVER)
func generate_noise_chunk_async(origin: Vector2i, size: Vector2i, seed: int = 0) -> void:
	WorkerThreadPool.add_task(_noise_chunk_task.bind(origin, size, seed))

func _noise_chunk_task(origin: Vector2i, size: Vector2i, seed: int) -> void:
	var noise := FastNoiseLite.new()
	noise.seed = seed
	var heights := PackedFloat32Array()
	heights.resize(size.x * size.y)
	var idx := 0
	for y in size.y:
		for x in size.x:
			heights[idx] = noise.get_noise_2d(float(origin.x + x), float(origin.y + y))
			idx += 1
	call_deferred("_emit_noise_chunk", origin, heights)

func _emit_noise_chunk(origin: Vector2i, heights: PackedFloat32Array) -> void:
	noise_chunk_ready.emit(origin, heights)

# 6. GridMap Snapping for Base Building
func get_snapped_pos(grid: GridMap, world_pos: Vector3) -> Vector3:
	var cell := grid.local_to_map(world_pos)
	return grid.map_to_local(cell)

func place_if_empty(grid: GridMap, world_pos: Vector3, item_id: int) -> bool:
	var cell := grid.local_to_map(world_pos)
	if grid.get_cell_item(cell) != GridMap.INVALID_CELL_ITEM:
		return false
	grid.set_cell_item(cell, item_id)
	return true

# 7. ConfigFile for Persistent Player Data
func save_unlocked_recipes(recipes: Array[StringName]) -> void:
	var config := ConfigFile.new()
	config.set_value("Player", "unlocked", recipes)
	config.save("user://progression.cfg")

# 8. Functional Inventory Filtering
func get_edible_items(inventory: Array) -> Array:
	return inventory.filter(func(item): return item.get(&"is_edible") == true)

# 9. Persistent Entity Save Extraction
func collect_world_state() -> Array:
	return get_tree().get_nodes_in_group(&"Persist").map(func(n): return n.call(&"save"))

# 10. Physics Body Freeing Wrapper
func safely_remove_entity(entity: Node) -> void:
	if is_instance_valid(entity):
		entity.queue_free()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — MultiMesh forests and threaded chunks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — GridMap snap base-building
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — Persist group / ConfigFile progression
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md
# =============================================================================
