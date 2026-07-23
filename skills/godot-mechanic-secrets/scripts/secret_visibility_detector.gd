class_name SecretVisibilityDetector
extends Node3D

## Expert Dot-Product Hidden Wall Detection.
## Triggers a fade if the player is looking directly at a 'faked' wall.

@export var sensitivity: float = 0.95 # Higher = more direct look required

func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera: return
	
	var to_node = (global_position - camera.global_position).normalized()
	var look_dot = camera.get_quaternion() * Vector3.FORWARD.dot(to_node)
	
	if look_dot > sensitivity:
		_on_player_looking()

func _on_player_looking() -> void:
	# Trigger shader transition or visibility toggle
	pass

## Tip: Use Dot Product instead of Raycasts for 'Look-at' triggers to reduce physics overhead.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/introduction_to_shaders.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — camera forward for look-at dots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — reveal/dissolve on look trigger
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
