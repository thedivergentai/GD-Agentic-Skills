# harvest_inventory_manager.gd
# [GDSKILLS] godot-game-loop-harvest
# EXPORT_REFERENCE: harvest_inventory_manager.gd

extends Node

signal inventory_updated(resource_name: String, new_amount: int)

var inventory: Dictionary = {}

func add_resource(resource: HarvestResourceData, amount: int) -> void:
	var id = resource.display_name
	if not inventory.has(id):
		inventory[id] = 0
	
	inventory[id] += amount
	inventory_updated.emit(id, inventory[id])
	print("Harvested %d %s. Total: %d" % [amount, id, inventory[id]])

func get_resource_count(resource_name: String) -> int:
	return inventory.get(resource_name, 0)

func has_resources(resource_name: String, amount: int) -> bool:
	return get_resource_count(resource_name) >= amount

func consume_resource(resource_name: String, amount: int) -> bool:
	if not has_resources(resource_name, amount):
		return false
		
	inventory[resource_name] -= amount
	inventory_updated.emit(resource_name, inventory[resource_name])
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — inventory_updated for UI decoupling
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — hub receives harvested; UI listens
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html — inventory dict belongs in save payload
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — replace dict hub with full stacking inventory
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — inventory_updated bus patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — consume_resource for sinks/crafting
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md
# =============================================================================
