# rhythm_conductor.gd
extends Node
class_name RhythmConductor

## Canonical audio clock: playback_position + mix offset + output latency.
## Do NOT use Time.get_ticks_* for song position. Drive highway/judging from get_song_time().

@export var bpm := 120.0
@export var offset := 0.0 # Manual calibration (seconds)
@export var audio_player: AudioStreamPlayer

func get_song_time() -> float:
	if audio_player == null or not audio_player.playing:
		return 0.0
	var t := audio_player.get_playback_position()
	t += AudioServer.get_time_since_last_mix()
	t -= AudioServer.get_output_latency()
	return maxf(0.0, t + offset)

func get_current_beat() -> float:
	return get_song_time() * (bpm / 60.0)

func beats_to_seconds(beats: float) -> float:
	return beats * (60.0 / bpm)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — mix latency and stream clock helpers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — typical Autoload home for the conductor
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — beat/measure signal ownership
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
