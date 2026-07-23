# Dynamic 3D Decal Placer
extends Node3D

## Expert pattern for placing high-performance decals 
## (impact holes, footsteps) without mesh generation.

@export var max_decals := 50
var _decal_count := 0

func place_impact_decal(pos: Vector3, normal: Vector3, texture: Texture2D) -> void:
	if _decal_count >= max_decals: return
	
	var decal = Decal.new()
	add_child(decal)
	decal.global_position = pos
	decal.look_at(pos + normal, Vector3.UP)
	
	decal.texture_albedo = texture
	decal.size = Vector3(0.5, 0.5, 0.5)
	
	# Important: Limit decal influence to environment layers only
	decal.cull_mask = 1 # Only affects Layer 1
	
	_decal_count += 1
	
	# Self-destruction timer
	get_tree().create_timer(10.0).timeout.connect(func():
		decal.queue_free()
		_decal_count -= 1
	)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_decals.html
# - https://docs.godotengine.org/en/stable/classes/class_decal.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — environmental detail without unique mats
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — impact FX pairing with decals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
