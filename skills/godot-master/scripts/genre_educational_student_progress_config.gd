# student_progress_config.gd
# Saving progress to human-readable ConfigFiles
extends Node

# EXPERT NOTE: ConfigFile is safer than JSON for educational settings 
# as it allows for structured sections and easier recovery.

var config = ConfigFile.new()
const SAVE_PATH = "user://student_profile.cfg"

func save_progress(level_id: String, score: int):
	config.load(SAVE_PATH)
	config.set_value("Progress", level_id, score)
	config.save(SAVE_PATH)

func get_score(level_id: String) -> int:
	config.load(SAVE_PATH)
	return config.get_value("Progress", level_id, 0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — production profile persistence patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Resource vs ConfigFile tradeoffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — feed mastery metrics into balance sims
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
