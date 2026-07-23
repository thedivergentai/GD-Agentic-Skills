# item_state_duplicator.gd
extends Node

# Deep Duplication of Inventory Items (State Management)
# Ensures identical items (like two handguns) can track ammo/durability independently
# by breaking the shared resource link.
func add_unique_item(base_item_resource: Resource) -> Resource:
    # duplicate(true) performs a deep copy of sub-resources.
    # In Godot 4, this ensures unique magazines/attachments for each instance.
    var unique_item := base_item_resource.duplicate(true)
    return unique_item
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — mutable ammo/durability per instance
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — duplicate(true) deep copy rules
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist unique item state
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
