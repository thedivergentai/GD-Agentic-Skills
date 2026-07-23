class_name EasterMeshPainterOverride
extends Node

## Expert seasonal material swapper for 3D meshes.
## Replaces standard surface materials with Easter-themed versions.

@export var mesh_instance: MeshInstance3D
@export var easter_material: Material

func apply_easter_material() -> void:
	if not mesh_instance or not easter_material: return
	
	# Expert: Use surface override to avoid modifying the Mesh resource itself.
	mesh_instance.set_surface_override_material(0, easter_material)

func remove_easter_material() -> void:
	if mesh_instance:
		mesh_instance.set_surface_override_material(0, null)

## Rule: Always use 'surface_override' for seasonal changes to preserve original assets.
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
