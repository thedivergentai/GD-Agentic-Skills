# card_tween_manager.gd
# Managing fluent and interruptible card animations
extends Node

# EXPERT NOTE: Always assign Tweens to variables to allow 
# kill() or parallel() management if board state changes fast.

func play_to_board(card: Control, target_pos: Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", target_pos, 0.4)
	# Interruptible: if card is destroyed, this tween stays clean.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — kill/parallel patterns for interruptible card juice
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — tween global_position vs layout containers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
