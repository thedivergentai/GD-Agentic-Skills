# fog_of_war_tile_mask.gd
extends Node2D
class_name FogOfWarTileMask

# TileMapLayer Fog of War Masking
# Efficiently clears Fog of War using the 2D TileMapLayer grid.

@export var fog_layer: TileMapLayer

func reveal_circular_area(world_pos: Vector2, radius_cells: int) -> void:
    if not fog_layer: return
    
    # Pattern: Map world position to discrete 2i grid coordinates.
    var center := fog_layer.local_to_map(fog_layer.to_local(world_pos))
    
    for x in range(-radius_cells, radius_cells + 1):
        for y in range(-radius_cells, radius_cells + 1):
            if Vector2(x, y).length() <= radius_cells:
                # pass -1 to layer to "clear" the fog cell.
                fog_layer.set_cell(center + Vector2i(x, y), -1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — TileMapLayer fog clear cells
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — vision-mask shader consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
