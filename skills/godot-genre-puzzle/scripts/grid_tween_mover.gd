extends Node2D
class_name GridTweenMover

## Expert Grid Movement (Godot 4.7).
## Separates logic (Vector2i) from visuals (Tween).

@export var tile_map: TileMapLayer
@export var move_time: float = 0.2

var logical_pos: Vector2i = Vector2i.ZERO
var _is_moving: bool = false

func move(direction: Vector2i) -> void:
	if _is_moving: return
	
	var target = logical_pos + direction
	if _can_move(target):
		_execute_move(target)

func _can_move(target: Vector2i) -> bool:
	var data = tile_map.get_cell_tile_data(target)
	return data != null and data.get_custom_data("walkable")

func _execute_move(target: Vector2i) -> void:
	_is_moving = true
	logical_pos = target # Update logic instantly
	
	var world_pos = tile_map.map_to_local(logical_pos)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", world_pos, move_time)
	tween.finished.connect(func(): _is_moving = false)

## [SKILL NOTICE]: Resolve logical state (Vector2i) IMMEDIATELY upon 
## valid input. Use Tweens ONLY for visual representation to avoid race conditions.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — TRANS/EASE presets for grid slides
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — map_to_local for visual targets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
