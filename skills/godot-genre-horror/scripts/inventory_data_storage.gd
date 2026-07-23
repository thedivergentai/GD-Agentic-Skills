# inventory_data_storage.gd
extends Node

# Strictly Typed Inventory Data Dictionary (RE/Silent Hill Style)
# Decouples inventory logic from the visual UI grid to ensure data integrity.
# Uses StringName (&"name") for optimized pointer-level lookups in the dictionary.
var inventory: Dictionary[StringName, Resource] = {
    &"mansion_key": null,
    &"handgun_ammo": null
}

func has_item(item_id: StringName) -> bool:
    return inventory.has(item_id) and inventory[item_id] != null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — typed Dictionary[StringName, Resource] slots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource definitions vs scene UI
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md — scarcity item budgets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
