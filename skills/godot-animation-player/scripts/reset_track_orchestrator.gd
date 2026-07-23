# reset_track_orchestrator.gd
# Robust RESET track management for multi-layered animations [12]
extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# EXPERT NOTE: If you have many entities, manually calling RESET 
# can be faster than letting Godot's auto-reset trigger layout updates.

func force_hard_reset() -> void:
	if anim_player.has_animation("RESET"):
		# Seek(0, true) forces immediate property application 
		# even if the player is paused.
		anim_player.play("RESET")
		anim_player.advance(0) # Immediate update
		anim_player.stop()

func play_safe(anim_name: String) -> void:
	# Always ensure we start from a clean slate if the previous 
	# animation modified persistent state.
	force_hard_reset()
	anim_player.play(anim_name)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_animationmixer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — RESET before scene swaps / pooled reuse
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — property restore after hybrid sprite timelines
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
