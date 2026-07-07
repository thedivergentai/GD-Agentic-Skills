extends Node
class_name RhythmScoringSystem

## Expert Rhythm Scoring (Godot 4.7).
## Precise hit detection using millisecond offsets.

const PERFECT_LIMIT = 0.02 # 20ms
const GREAT_LIMIT = 0.05   # 50ms
const GOOD_LIMIT = 0.10    # 100ms

func evaluate_hit(conductor_time: float, target_time: float) -> String:
	var offset = abs(conductor_time - target_time)
	
	if offset <= PERFECT_LIMIT: return "PERFECT"
	if offset <= GREAT_LIMIT: return "GREAT"
	if offset <= GOOD_LIMIT: return "GOOD"
	return "MISS"

## [SKILL NOTICE]: Use absolute time difference for scoring. 
## Millisecond accuracy is the industry standard for rhythm games.
