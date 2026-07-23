# first_person_sway.gd
# Procedural head-bob and weapon sway for FPS games [212]
extends Camera3D

@export var bob_freq: float = 2.0
@export var bob_amp: float = 0.08
var _time: float = 0.0

func _process(delta: float) -> void:
	var velocity = get_parent().velocity if get_parent() is CharacterBody3D else Vector3.ZERO
	var horizontal_vel = Vector2(velocity.x, velocity.z).length()
	
	if horizontal_vel > 0.1:
		_time += delta * horizontal_vel
		# 8-figure head bob
		var bob = Vector3.ZERO
		bob.y = sin(_time * bob_freq) * bob_amp
		bob.x = cos(_time * bob_freq * 0.5) * bob_amp
		transform.origin = bob
	else:
		_time = 0
		transform.origin = transform.origin.lerp(Vector3.ZERO, delta * 5.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — parent CharacterBody3D velocity source
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — mouse capture / look axes for FPS
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — local-origin bob without fighting look_at
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
