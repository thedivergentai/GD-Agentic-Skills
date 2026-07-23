class_name HSMStateHistoryLogger
extends Node

## Expert Debug tool for State Machine History.
## Tracks a ring buffer of recent transitions for troubleshooting.

var history: Array[String] = []
@export var max_history: int = 20

func log_transition(from: String, to: String) -> void:
	var entry := "[%s] %s -> %s" % [Time.get_time_string_from_system(), from, to]
	history.push_back(entry)
	if history.size() > max_history:
		history.pop_front()

## Tip: Expose 'history' to the in-game debug console.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — assert transition sequences against the ring buffer
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — subscribe to transitioned for history without polling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
