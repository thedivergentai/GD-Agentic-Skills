class_name VRPhysicsHandController
extends CharacterBody3D

## Expert physics-based hand for immersive VR interactions.
## Prevents hands from clipping through walls by following the XR controller via physics.

@export var target_controller: XRController3D
@export var follow_speed: float = 20.0

func _physics_process(delta: float) -> void:
	if not target_controller: return
	
	# Compute velocity needed to reach controller position
	var target_pos := target_controller.global_position
	var diff := target_pos - global_position
	velocity = diff * follow_speed
	
	move_and_slide()

## Tip: Use 'move_and_slide' to ensure hands slide against surfaces naturally.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_xrcontroller3d.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — move_and_slide hands that respect solids
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — physics_process follow toward controllers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
