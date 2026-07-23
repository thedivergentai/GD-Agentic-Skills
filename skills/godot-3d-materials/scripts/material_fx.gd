# skills/3d-materials/scripts/material_fx.gd
extends Node

## Material FX (Expert Pattern)
## Runtime material mutation helpers. ALWAYS duplicate (or enable local-to-scene)
## before tweaking shared .tres / surface overrides — otherwise every instance flashes.

class_name MaterialFX

static func ensure_unique_override(mesh: MeshInstance3D, surface: int = 0) -> Material:
	## Returns a mesh-local material safe to mutate at runtime.
	var existing := mesh.get_surface_override_material(surface)
	if existing == null:
		existing = mesh.get_active_material(surface)
	if existing == null:
		return null
	if mesh.material_override != null and mesh.material_override == existing:
		var dup_override: Material = existing.duplicate(true)
		mesh.material_override = dup_override
		return dup_override
	var unique: Material = existing.duplicate(true)
	mesh.set_surface_override_material(surface, unique)
	return unique

static func flash_white(mesh: MeshInstance3D, duration: float = 0.1) -> void:
	# Overlay avoids mutating the shared albedo material when possible.
	var flash_mat := StandardMaterial3D.new()
	flash_mat.albedo_color = Color.WHITE
	flash_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	flash_mat.transparency = BaseMaterial3D.TRANSPARENCY_ADD

	mesh.material_overlay = flash_mat

	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(duration).timeout

	if is_instance_valid(mesh):
		mesh.material_overlay = null

static func dissolve_scissor(mesh: MeshInstance3D, duration: float = 1.0) -> void:
	## Alpha-scissor dissolve on a UNIQUE override — never tween a shared .tres.
	var mat := ensure_unique_override(mesh) as StandardMaterial3D
	if mat == null:
		return
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	var tween := mesh.create_tween()
	tween.tween_property(mat, "alpha_scissor_threshold", 1.0, duration).from(0.0)

## EXPERT USAGE:
## 1. Prefer material_overlay for flashes (no shared-resource mutation).
## 2. For parameter tweens, call ensure_unique_override() or enable Local To Scene on the material.
## 3. Call MaterialFX.flash_white(self) / dissolve_scissor(self) from damage/VFX owners.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_standardmaterial3d.html
# - https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — dissolve/flash often graduate to ShaderMaterial
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — emission/HDR for glow damage states
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
