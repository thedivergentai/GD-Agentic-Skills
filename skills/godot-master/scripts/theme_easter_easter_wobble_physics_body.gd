class_name EasterWobblePhysicsBody
extends RigidBody3D

## Expert wobbly physics for 'Egg-like' interaction.
## Applies a random offset to the center of mass to create organic instability.

func _ready() -> void:
	# Shift center of mass slightly to cause a wobble when it rolls
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector3(randf_range(-0.1, 0.1), -0.2, randf_range(-0.1, 0.1))

## Tip: Low friction + Custom Center of Mass = High quality organic egg motion.
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
