# dynamic_resource_generation.gd
# Creating and modifying Resources at runtime
extends Node

func create_procedural_loot():
	var loot = ItemData.new("Magic Sword", 500)
	loot.description = "Generated at: " + Time.get_datetime_string_from_system()
	
	# We can now pass this around as a lightweight data object
	_give_to_player(loot)

func _give_to_player(_item: ItemData):
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — runtime Resource.new() for loot/quests
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — handing generated ItemData into bags
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
