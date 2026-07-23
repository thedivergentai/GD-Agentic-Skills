class_name SeasonalMaterialSwapper
extends Node

## A utility to swap materials based on the "Season".
## Needs to be attached to a MeshInstance3D or have one assigned.

enum Season { DEFAULT, EASTER }

@export var target_mesh: MeshInstance3D
@export var default_material: Material
@export var easter_material: Material

# Could be a global singleton or local export
@export var current_season: Season = Season.DEFAULT

func _ready() -> void:
	if not target_mesh:
		target_mesh = get_parent() as MeshInstance3D
		
	apply_season()

func apply_season() -> void:
	if not target_mesh:
		return
		
	var mat_to_use = default_material
	
	match current_season:
		Season.EASTER:
			if easter_material:
				mat_to_use = easter_material
	
	# Override surface 0 (usually the main material)
	target_mesh.set_surface_override_material(0, mat_to_use)

func set_season(new_season: Season) -> void:
	current_season = new_season
	apply_season()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — base Theme architecture
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — confetti/shimmer VFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md
# =============================================================================
