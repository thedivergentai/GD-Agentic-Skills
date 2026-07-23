# text_counter_method_tween.gd
# Animating abstract values using tween_method [Score Counters]
extends Label

# EXPERT NOTE: Use tween_method to animate values that aren't 
# direct properties, like UI text or custom shader parameters.

func update_score(target: int):
	var curr_score = int(text.split(": ")[1])
	var tween = create_tween()
	
	# Calls '_set_score_text' with an interpolated int value
	tween.tween_method(_set_score_text, curr_score, target, 1.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _set_score_text(val: int):
	text = "Score: " + str(val)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_methodtweener.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — label/score presentation while values tween
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed callables for tween_method
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
