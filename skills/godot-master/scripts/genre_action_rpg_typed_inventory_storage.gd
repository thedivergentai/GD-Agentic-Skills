# typed_inventory_storage.gd
extends Node
class_name TypedInventoryStorage

# Strongly Typed Inventory Dictionaries
# Enforces data safety and performance for thousands of persistent RPG items.

# Pattern: Use [StringName, Resource] for high-speed lookup and type safety.
var equipment_slots: Dictionary[StringName, Resource] = {
    &"head": null,
    &"chest": null,
    &"weapon": null
}

func equip_resource(slot: StringName, item: Resource) -> void:
    if equipment_slots.has(slot):
        equipment_slots[slot] = item
        _on_item_equipped(slot, item)

func _on_item_equipped(slot: StringName, item: Resource) -> void:
    # Trigger visual updates or stat recalculations.
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — equipment slot Resources
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html — Dictionary[StringName, Resource]
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — equip/unequip + rarity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — recalc on gear change
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
