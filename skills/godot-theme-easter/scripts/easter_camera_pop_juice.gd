class_name EasterCameraPopJuice
extends Camera3D

## Expert camera juice for 'Egg Pops' or collection events.
## Pulses the FOV temporarily to emphasize the impact.

func trigger_pop_kick(strength: float = 5.0) -> void:
	var base_fov := fov
	var tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "fov", base_fov + strength, 0.05)
	tween.tween_property(self, "fov", base_fov, 0.2)

## Rule: FOV kicks should be subtle (< 10 degrees) to avoid motion sickness.
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
