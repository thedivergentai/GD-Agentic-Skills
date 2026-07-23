# spaced_repetition_scheduler.gd
# Interval queue for long-term retention (SM-2-lite).
extends RefCounted
class_name SpacedRepetitionScheduler

## question_id -> unix timestamp when eligible again
var _due_at: Dictionary = {}
## question_id -> consecutive successes (interval ladder)
var _streak: Dictionary = {}

const INTERVALS_SEC: Array[float] = [60.0, 300.0, 1800.0, 86400.0, 259200.0]

func record_result(question_id: StringName, correct: bool, now: float = -1.0) -> void:
	if now < 0.0:
		now = Time.get_unix_time_from_system()
	if correct:
		var s: int = int(_streak.get(question_id, 0)) + 1
		_streak[question_id] = s
		var idx: int = mini(s - 1, INTERVALS_SEC.size() - 1)
		_due_at[question_id] = now + INTERVALS_SEC[idx]
	else:
		_streak[question_id] = 0
		_due_at[question_id] = now  # immediately eligible

func next_due(candidates: Array[StringName], now: float = -1.0) -> StringName:
	if now < 0.0:
		now = Time.get_unix_time_from_system()
	var best: StringName = &""
	var best_due: float = INF
	for q in candidates:
		var due: float = float(_due_at.get(q, 0.0))
		if due <= now and due < best_due:
			best_due = due
			best = q
	if best != &"":
		return best
	# Nothing due — pick soonest future (or first candidate)
	for q in candidates:
		var due2: float = float(_due_at.get(q, 0.0))
		if due2 < best_due:
			best_due = due2
			best = q
	return best if best != &"" else (candidates[0] if candidates else &"")

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — question banks as Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — retention interval fairness
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
