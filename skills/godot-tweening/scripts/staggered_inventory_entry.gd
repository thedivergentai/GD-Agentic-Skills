# staggered_inventory_entry.gd
# Looping through collections for sequential entry effects
extends GridContainer

func animate_items():
	var tween = create_tween()
	
	# Because set_parallel is false, these run one-by-one
	for child in get_children():
		child.scale = Vector2.ZERO
		tween.tween_property(child, "scale", Vector2.ONE, 0.15)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		# Expert: Use a tiny interval if you want them to overlap slightly
		# tween.set_parallel(true).tween_interval(0.05).set_parallel(false)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_intervaltweener.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — slot entry stagger on open
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — GridContainer children as tween targets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
