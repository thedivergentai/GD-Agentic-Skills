# dynamic_bpm_handler.gd
extends Node
class_name DynamicBPMHandler

# Handling Mid-Song Tempo Changes
# Adjusts beat calculation based on tempo map markers.

struct BPMMarker:
    var beat: float
    var time: float
    var bpm: float

var bpm_markers: Array[BPMMarker] = []

func get_beat_at_time(song_time: float) -> float:
    # Pattern: Find the most recent BPM marker and calculate beat offset.
    var current_marker = bpm_markers[0]
    for marker in bpm_markers:
        if marker.time <= song_time:
            current_marker = marker
        else:
            break
            
    var elapsed = song_time - current_marker.time
    return current_marker.beat + (elapsed * (current_marker.bpm / 60.0))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — tempo-aware interactive/stream switches
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — tempo-map Resource schemas
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — marker arrays and beat math
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
