# latency_calibrator.gd
extends Node
class_name LatencyCalibrator

# Audio-Visual Offset Correction
# Allows players to adjust the delay between sound and visuals.

var user_offset := 0.0 # Stored in user config

func start_calibration_test() -> void:
    # Measure delta between visual flash and player keypress.
    pass

func apply_offset(conductor: RhythmConductor) -> void:
    # Pattern: Update the conductor's internal offset with calibrated value.
    conductor.offset = user_offset
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — output latency and playback position APIs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — tap timestamps during calibration
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist user A/V offset
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
