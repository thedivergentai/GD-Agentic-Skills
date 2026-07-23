class_name LagCompensator
extends Node
## Server-side position history for rewind hit validation.

const MAX_BACKTRACK_MS := 200

var _history: Array[Dictionary] = []  # { "time": int, "transform": Transform3D }

func _physics_process(_delta: float) -> void:
	_history.append({
		"time": Time.get_ticks_msec(),
		"transform": owner.global_transform
	})
	if _history.size() > 60:
		_history.pop_front()

func backtrack_to(timestamp: int) -> void:
	if _history.is_empty():
		return
	var best := _history[0]
	for entry in _history:
		if absi(entry.time - timestamp) < absi(best.time - timestamp):
			best = entry
	owner.global_transform = best.transform

func restore_latest() -> void:
	if not _history.is_empty():
		owner.global_transform = _history[-1].transform

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — prediction shells
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — RPC authority
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md
# =============================================================================
