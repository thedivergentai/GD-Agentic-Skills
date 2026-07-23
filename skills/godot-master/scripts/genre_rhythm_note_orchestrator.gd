extends Node
class_name NoteOrchestrator

## Expert Note Orchestrator (Godot 4.7).
## Spawns and positions notes purely based on timeline math.

@export var conductor: RhythmConductor
@export var bpm: float = 120.0
@export var scroll_speed: float = 500.0 # Pixels per beat

func _process(_delta: float) -> void:
	var current_beat = conductor.get_current_beat(bpm)
	_update_note_positions(current_beat)

func _update_note_positions(current_beat: float) -> void:
	# Group: "active_notes"
	for note in get_tree().get_nodes_in_group("active_notes"):
		var beats_away = note.target_beat - current_beat
		# Interpolate visual position based on time distance
		note.position.y = beats_away * scroll_speed

## [SKILL NOTICE]: Use 'beats_away' to position notes. This ensures 
## visual consistency regardless of framerate or lag spikes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — conductor time for spawn windows
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — active note counts vs hitch risk
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — chart NoteData resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
