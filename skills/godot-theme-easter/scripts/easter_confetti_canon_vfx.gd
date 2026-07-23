class_name EasterConfettiCanonVFX
extends GPUParticles3D

## Expert confetti canon for celebratory Easter events.
## Emits multi-colored pastel flakes with gravity and rotation.

func burst() -> void:
	amount = 100
	one_shot = true
	emitting = true

## Tip: Use 'collision_mode' on particles to have confetti land on the ground.
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
