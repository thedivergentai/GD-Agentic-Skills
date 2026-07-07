class_name MinimapFog
extends SubViewport

## Expert Minimap Fog (Godot 4.7).
## TileMapLayer-based discovery and fog-of-war.

@export var fog_layer: TileMapLayer
@export var player: Node2D

func _physics_process(_delta: float) -> void:
	if not player or not fog_layer: return
	
	var pos = fog_layer.local_to_map(player.global_position)
	_reveal_radius(pos, 2)

func _reveal_radius(center: Vector2i, radius: int) -> void:
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var cell = center + Vector2i(x, y)
			# Erase black fog tile
			fog_layer.set_cell(cell, -1)

## [SKILL NOTICE]: Use 'TileMapLayer' (4.3+) for best performance. 
## Erasing cells with '-1' ID is faster than changing tile visibility.
