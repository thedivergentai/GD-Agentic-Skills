# quest_persistence_loader.gd
# Saving and loading quest progress
extends Node

# EXPERT NOTE: Save quest IDs and their current progress count 
# to a dictionary for easy JSON or ConfigFile serialization.

func get_save_data() -> Dictionary:
	var data = {}
	for id in QuestManager.active_quests:
		var q = QuestManager.active_quests[id]
		data[id] = q.current_count
	return data

func load_save_data(data: Dictionary):
	# Assumes you have a central 'QuestDatabase' to load base resources
	for id in data:
		var q_res = QuestDatabase.get_quest(id)
		if q_res:
			QuestManager.accept_quest(q_res)
			QuestManager.update_objective(id, data[id])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — slot save of quest ID → progress maps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — reload base Quest Resources from a database, then apply progress
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
