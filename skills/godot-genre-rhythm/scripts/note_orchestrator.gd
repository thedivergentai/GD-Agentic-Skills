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
