extends Node
class_name LapCheckpointManager

## Expert Lap Manager (Godot 4.7).
## Sequence-validated checkpoints to prevent cheating.

signal lap_completed(total_laps: int)

var next_expected_id: int = 1
var current_lap: int = 0
@export var total_checkpoints: int = 4

func _on_checkpoint_passed(id: int) -> void:
	if id == next_expected_id:
		if id == total_checkpoints:
			next_expected_id = 1
			current_lap += 1
			lap_completed.emit(current_lap)
		else:
			next_expected_id += 1
	else:
		print("Cheated or skipped! Expected %d, got %d" % [next_expected_id, id])

## [SKILL NOTICE]: Use 'Sequence-ID' validation (1 -> 2 -> 3) rather 
## than just distance to prevent players from bypassing the track.
