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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — score/miss economy vs clear rate
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — judgment → score event wiring
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed judgment enums and offsets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
