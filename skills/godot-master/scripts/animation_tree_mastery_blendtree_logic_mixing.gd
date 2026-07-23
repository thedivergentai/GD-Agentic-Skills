# blendtree_logic_mixing.gd
# Complex BlendTree configuration and dynamic weight mixing [189]
extends AnimationTree

# Expert: Mixing multiple Add2/Blend2 nodes to create a combat layer
# that respects lower body movement.

func set_combat_mix(weight: float) -> void:
	# 0.0 = Pure Movement
	# 1.0 = Pure Combat/Aim
	
	# Animating multiple weights in sync
	set("parameters/UpperBodyBlend/blend_amount", weight)
	set("parameters/ArmIKWeight/blend_amount", weight)
	
	# If weight is high, maybe increase the TimeScale of upper body
	if weight > 0.8:
		set("parameters/CombatSpeed/scale", 1.2)
	else:
		set("parameters/CombatSpeed/scale", 1.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodeblendtree.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodeblend2.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodetimescale.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — aim/combat mix weights
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md — layered aim while moving
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
