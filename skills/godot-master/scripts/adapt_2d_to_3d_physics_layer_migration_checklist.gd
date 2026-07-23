# physics_layer_migration_checklist.gd
# [GDSKILLS] godot-adapt-2d-to-3d
# EXPORT_REFERENCE: physics_layer_migration_checklist.gd

extends RefCounted

## Checklist helpers for migrating 2D physics layers/masks into 3D.
## 2D and 3D layer name tables are SEPARATE in Project Settings — copying
## bitmasks without renaming 3D Physics layers is a silent miss.

class_name PhysicsLayerMigrationChecklist

static func project_settings_keys() -> PackedStringArray:
	return PackedStringArray([
		"layer_names/3d_physics/layer_1",
		"layer_names/3d_physics/layer_2",
		"layer_names/3d_physics/layer_3",
		"layer_names/3d_physics/layer_4",
	])

static func assert_named_layers(expected: Dictionary) -> PackedStringArray:
	## expected: {1: "Player", 2: "Enemies", ...} — 1-based layer indices.
	var missing: PackedStringArray = []
	for idx in expected:
		var key := "layer_names/3d_physics/layer_%d" % int(idx)
		var name := str(ProjectSettings.get_setting(key, ""))
		if name != str(expected[idx]):
			missing.append("%s expected '%s' got '%s'" % [key, expected[idx], name])
	return missing

static func apply_body_bits(body: CollisionObject3D, layer_bit: int, mask_bits: int) -> void:
	body.collision_layer = layer_bit
	body.collision_mask = mask_bits

static func migration_steps() -> PackedStringArray:
	return PackedStringArray([
		"Open Project Settings → Layer Names → 3D Physics (not 2D Physics).",
		"Mirror your 2D layer names into 3D slots (Player/Enemies/World/…).",
		"Update every CharacterBody3D/Area3D/StaticBody3D layer+mask.",
		"Re-author Shape3D resources — Shape2D does not convert.",
		"Verify with visible collision shapes + one physics frame before queries.",
		"Do NOT Load lighting deep-dives here — route to godot-3d-lighting.",
	])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_collisionobject3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-2d-to-3d/SKILL.md
# =============================================================================
