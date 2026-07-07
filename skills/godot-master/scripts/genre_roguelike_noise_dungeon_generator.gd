extends Node2D
class_name NoiseDungeonGenerator

## Expert Dungeon Generation (Godot 4.7).
## Uses FastNoiseLite for organic caves and AStarGrid2D for connectivity.

@export var tile_map: TileMapLayer
@export var width: int = 64
@export var height: int = 64
@export var wall_threshold: float = 0.2

var _noise := FastNoiseLite.new()
var _astar := AStarGrid2D.new()

func generate() -> void:
	_noise.seed = randi()
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	_astar.region = Rect2i(0, 0, width, height)
	_astar.update()
	
	for x in range(width):
		for y in range(height):
			var pos = Vector2i(x, y)
			if _noise.get_noise_2d(x, y) > wall_threshold:
				tile_map.set_cell(pos, 0, Vector2i(0,0)) # Wall
				_astar.set_point_solid(pos, true)
			else:
				tile_map.set_cell(pos, 1, Vector2i(1,0)) # Floor

	# Expert Tip: Use _astar.get_id_path() to check connectivity 
	# and carve corridors between isolated noise islands.

## [SKILL NOTICE]: Use 'AStarGrid2D' to validate connectivity in noise-based 
## dungeons. It is highly optimized for 2D grids and corridor carving.
