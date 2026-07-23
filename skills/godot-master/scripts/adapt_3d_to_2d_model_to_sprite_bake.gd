# model_to_sprite_bake.gd
# [GDSKILLS] godot-adapt-3d-to-2d
# EXPORT_REFERENCE: model_to_sprite_bake.gd

@tool
extends Node3D

## MANDATORY for automated 3D→sprite bake pipelines.
## Renders a loaded GLB/scene from N yaw angles into PNGs via SubViewport.
## Keep SKILL.md as strategy router — do not re-inline this recipe in the body.

@export var model_path: String = "res://models/character.glb"
@export var output_dir: String = "res://sprites/"
@export var angles: int = 8
@export var viewport_size: Vector2i = Vector2i(256, 256)
@export var camera_position: Vector3 = Vector3(0, 2, 5)
@export var bake: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			bake_sprites()

func bake_sprites() -> void:
	if model_path.is_empty():
		push_error("model_to_sprite_bake: model_path empty")
		return
	var packed := load(model_path) as PackedScene
	if packed == null:
		push_error("model_to_sprite_bake: failed to load %s" % model_path)
		return
	var model := packed.instantiate() as Node3D
	add_child(model)

	var viewport := SubViewport.new()
	viewport.size = viewport_size
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)

	var camera := Camera3D.new()
	camera.position = camera_position
	camera.look_at(Vector3.ZERO)
	viewport.add_child(camera)
	camera.current = true

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_dir))
	for i in range(angles):
		model.rotation.y = (TAU / float(angles)) * float(i)
		await RenderingServer.frame_post_draw
		var img := viewport.get_texture().get_image()
		img.save_png("%s/sprite_%d.png" % [output_dir, i])

	model.queue_free()
	viewport.queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
