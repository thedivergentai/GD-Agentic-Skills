# fog_grid_mask.gd
extends Node2D
class_name FogGridMask

# TileMapLayer Fog of War Masking
# Efficiently clears grid cells based on unit vision radius.

@export var fog_layer: TileMapLayer

func reveal_circle(world_pos: Vector2, cell_radius: int) -> void:
    if not fog_layer: return
    
    # Convert world to local grid coordinates.
    var center_cell: Vector2i = fog_layer.local_to_map(fog_layer.to_local(world_pos))
    
    # Iterate through a square bounding box and clear within the radius.
    for x in range(-cell_radius, cell_radius + 1):
        for y in range(-cell_radius, cell_radius + 1):
            if Vector2(x, y).length() <= cell_radius:
                # -1 source_id clears the cell in Godot 4 TileMapLayer.
                fog_layer.set_cell(center_cell + Vector2i(x, y), -1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md — tile fog mask UX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — grid reveal cost
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
