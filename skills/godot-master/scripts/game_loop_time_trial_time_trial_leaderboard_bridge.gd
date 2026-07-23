class_name TimeTrialLeaderboardBridge
extends Node

## Helper for formatting time trial results and bridging to leaderboards.
## Converts raw milliseconds/ticks into human-readable MM:SS.mmm format.

## Formats milliseconds into "MM:SS.mmm"
static func format_msec(msec_total: int) -> String:
	var msec := msec_total % 1000
	var seconds := (msec_total / 1000) % 60
	var minutes := (msec_total / 60000)
	return "%02d:%02d.%03d" % [minutes, seconds, msec]

## Formats physics frames into "MM:SS.mmm" based on engine tick rate
static func format_frames(frames: int) -> String:
	var ticks_per_sec = Engine.physics_ticks_per_second
	var msec_total = int((float(frames) / ticks_per_sec) * 1000.0)
	return format_msec(msec_total)

## Utility to calculate current session time
var start_tick: int = 0

func start_session() -> void:
	start_tick = Engine.get_physics_frames()

func get_elapsed_formatted() -> String:
	var current = Engine.get_physics_frames()
	return format_frames(current - start_tick)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — store integer msec records instead of float display strings
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — HUD labels consuming format_msec / format_frames
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md
# =============================================================================
