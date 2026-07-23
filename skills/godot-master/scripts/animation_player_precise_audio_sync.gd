# precise_audio_sync.gd
# Using TYPE_AUDIO tracks for perfect timing with pitch/volume control [93]
extends AnimationPlayer

func add_dynamic_sfx(anim: Animation, stream: AudioStream, time: float) -> void:
	var track_idx = anim.add_track(Animation.TYPE_AUDIO)
	track_set_path(track_idx, "AudioStreamPlayer")
	
	# Expert: Audio tracks handle polyphony and volume ramping internally
	anim.audio_track_insert_key(track_idx, time, stream)
	
	# Control volume (-60 to 24 dB)
	anim.audio_track_set_key_volume(track_idx, 0, -3.0) 
	
	# Use START_OFFSET to skip introductory silence in long files
	anim.audio_track_set_key_start_offset(track_idx, 0, 0.1)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html
# - https://docs.godotengine.org/en/stable/classes/class_animation.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — voice limits and bus routing for keyed SFX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md — seek-synced timelines vs speed_scale drift
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
