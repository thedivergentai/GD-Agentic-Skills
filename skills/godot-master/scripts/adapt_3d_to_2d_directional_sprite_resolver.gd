class_name DirectionalSpriteResolver
extends Sprite3D

## Expert Directional Sprite Resolver (Godot 4.7).
## Calculates the 8-way (Doom/Octopath style) frame index based on camera view.

@export var camera: Camera3D
@export var character: Node3D

func _process(_delta: float) -> void:
	if not camera or not character: return
	
	# 1. Extract Forward Vectors (-Z is forward in Godot)
	var cam_forward: Vector3 = -camera.global_transform.basis.z
	var char_forward: Vector3 = -character.global_transform.basis.z
	
	# 2. Get Signed Angle around UP axis
	var angle: float = char_forward.signed_angle_to(cam_forward, Vector3.UP)
	
	# 3. Map Radians (-PI to PI) to 8 Slices (45 degrees each)
	var direction_index: int = int(round(angle / (PI / 4.0)))
	if direction_index < 0:
		direction_index += 8
		
	# 4. Set Frame (Ensure your sprite sheet is ordered 0-7 for N, NE, E, SE, etc.)
	frame = direction_index

## [SKILL NOTICE]: Use 'signed_angle_to' with Vector3.UP to accurately map 
## character orientation relative to the camera for 2.5D directional sprites.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_sprite3d.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — 8-way sheet ordering
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — camera-relative facing
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
