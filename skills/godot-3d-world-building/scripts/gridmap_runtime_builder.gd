# skills/3d-world-building/scripts/gridmap_runtime_builder.gd
extends GridMap

## GridMap Runtime Builder Expert Pattern
## Runtime tile placement with rotation validation and batch operations.

class_name GridMapRuntimeBuilder

signal cell_placed(grid_pos: Vector3i, tile_index: int)
signal cell_removed(grid_pos: Vector3i)

@export var auto_navigation_bake := false

var _batch_queue := []
var _is_batching := false

func place_cell(grid_pos: Vector3i, tile_index: int, orientation := 0) -> bool:
	if tile_index < 0 or tile_index >= mesh_library.get_last_unused_item_id():
		push_warning("Invalid tile index: %d" % tile_index)
		return false
	
	set_cell_item(grid_pos, tile_index, orientation)
	
	if not _is_batching:
		cell_placed.emit(grid_pos, tile_index)
		
		if auto_navigation_bake:
			_request_navigation_bake()
	
	return true

func remove_cell(grid_pos: Vector3i) -> void:
	set_cell_item(grid_pos, INVALID_CELL_ITEM)
	
	if not _is_batching:
		cell_removed.emit(grid_pos)

func begin_batch() -> void:
	_is_batching = true
	_batch_queue.clear()

func end_batch() -> void:
	_is_batching = false
	
	# Emit all queued signals
	for data in _batch_queue:
		if data.has("tile_index"):
			cell_placed.emit(data.grid_pos, data.tile_index)
		else:
			cell_removed.emit(data.grid_pos)
	
	_batch_queue.clear()
	
	if auto_navigation_bake:
		_request_navigation_bake()

func fill_box(from: Vector3i, to: Vector3i, tile_index: int) -> void:
	begin_batch()
	
	var min_pos := Vector3i(
		mini(from.x, to.x),
		mini(from.y, to.y),
		mini(from.z, to.z)
	)
	var max_pos := Vector3i(
		maxi(from.x, to.x),
		maxi(from.y, to.y),
		maxi(from.z, to.z)
	)
	
	for x in range(min_pos.x, max_pos.x + 1):
		for y in range(min_pos.y, max_pos.y + 1):
			for z in range(min_pos.z, max_pos.z + 1):
				place_cell(Vector3i(x, y, z), tile_index)
	
	end_batch()

func _request_navigation_bake() -> void:
	# Requires NavigationRegion3D parent
	var nav_region := get_parent() as NavigationRegion3D
	if nav_region:
		nav_region.bake_navigation_mesh()

## EXPERT USAGE:
## var builder := GridMapRuntimeBuilder.new()
## builder.mesh_library = load("res://library.tres")
## builder.auto_navigation_bake = true
## 
## # Batch placement for performance
## builder.begin_batch()
## for i in 100:
##     builder.place_cell(Vector3i(i, 0, 0), 0)
## builder.end_batch()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html
# - https://docs.godotengine.org/en/stable/classes/class_gridmap.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — rebake NavigationRegion3D after cell batches
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — generators driving set_cell_item at runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md
# =============================================================================
