# visionary_comparison.gd
# Expert utility for storing and comparing audit scores over time.
# Grounded in Godot 4.x ConfigFile serialization.

extends RefCounted

class_name VisionaryComparison

const SAVE_PATH := "user://visionary_comparison.cfg"

## Saves a new audit score to the comparison log.
static func save_run_result(run_name: String, score: float, metadata: Dictionary = {}) -> void:
	var config := ConfigFile.new()
	config.load(SAVE_PATH) # Load existing data if it exists
	
	config.set_value("runs", run_name, {
		"score": score,
		"timestamp": Time.get_datetime_string_from_system(),
		"metadata": metadata
	})
	
	config.save(SAVE_PATH)

## Compares the current run against a previous baseline.
static func compare_with_baseline(current_run: String, baseline_run: String) -> String:
	var config := ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err != OK:
		return "No comparison data found at %s." % SAVE_PATH
		
	var current = config.get_value("runs", current_run, null)
	var baseline = config.get_value("runs", baseline_run, null)
	
	if current == null or baseline == null:
		return "Missing run data for comparison (%s vs %s)." % [current_run, baseline_run]
		
	var diff = current["score"] - baseline["score"]
	var trend = "IMPROVING" if diff > 0 else "REGRESSING"
	if diff == 0: trend = "STABLE"
	
	return "Trend: %s (Delta: %+.2f pts)" % [trend, diff]
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — durable user:// baselines for trend deltas
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — regression gates on score decay
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
# =============================================================================
