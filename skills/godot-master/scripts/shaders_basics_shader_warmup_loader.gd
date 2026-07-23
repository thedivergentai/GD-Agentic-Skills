extends Node
## Pre-warm shader pipelines during loading screens to avoid first-frame stutter.

func warmup_scenes(scenes: Array[PackedScene]) -> void:
	for scene in scenes:
		var inst := scene.instantiate()
		add_child(inst)
		if inst is Node3D:
			(inst as Node3D).position = Vector3(0, 0, -5)
	await RenderingServer.frame_post_draw
	for child in get_children():
		child.queue_free()
