# engine_audio_controller.gd
extends AudioStreamPlayer3D
class_name EngineAudioController

# Engine Audio Simulation (Pitch-Based RPM)
# Maps vehicle speed/RPM to audio pitch for realistic revving.

@export var min_pitch := 0.5
@export var max_pitch := 2.5
@export var speed_scale := 0.05

func update_engine_sound(current_speed: float) -> void:
    # Pattern: Calculate pitch based on speed/RPM curve.
    var target_pitch = min_pitch + (current_speed * speed_scale)
    pitch_scale = lerp(pitch_scale, clamp(target_pitch, min_pitch, max_pitch), 0.1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — bus/Doppler layering for engines
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — throttle axis to RPM mapping
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
