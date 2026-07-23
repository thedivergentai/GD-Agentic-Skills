# relative_recoil_tween.gd
# Relative position offsets with as_relative() and from_current()
extends Sprite2D

# EXPERT NOTE: Use as_relative() for recoil or camera nudges so you 
# don't need to know the 'base' value.

func shoot_recoil(strength: float):
	var tween = create_tween()
	# Relative movement from WHEREVER it is now
	tween.tween_property(self, "position:x", -strength, 0.05)\
		.as_relative().from_current().set_trans(Tween.TRANS_SINE)
		
	# Snap back to center
	tween.chain().tween_property(self, "position:x", 0, 0.2)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_propertytweener.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — relative camera nudges on fire
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md — weapon recoil juice without base-position tracking
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
