# dictionary_safe_iteration.gd
# Correct pattern for deleting keys during iteration
extends Node

func cleanup_expired_data(data: Dictionary):
	# NEVER erase from the dict while iterating it directly.
	# Create a copy of keys to iterate instead.
	var keys_to_check = data.keys()
	
	for key in keys_to_check:
		if _is_expired(data[key]):
			data.erase(key) # Safe because we iterate the clone

func _is_expired(_val) -> bool:
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_dictionary.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — erase expired save keys safely
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — mutate Resource dicts without iterator bugs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
