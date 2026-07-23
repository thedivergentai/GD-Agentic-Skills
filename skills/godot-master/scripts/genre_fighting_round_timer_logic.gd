# round_timer_logic.gd
# Deterministic round management without Node timers
extends Node

# EXPERT NOTE: In fighting games, the timer must stay in sync 
# with the frames, not the wall-clock time.

var frames_remaining: int = 60 * 60 # 60 seconds at 60fps

func _physics_process(_delta):
	if frames_remaining > 0:
		frames_remaining -= 1
		if frames_remaining == 0:
			_on_time_out()

func _on_time_out():
	print("Round Ended by Frame Count")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — round timeout / match-end events
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — timeout win-rate simulation knobs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
