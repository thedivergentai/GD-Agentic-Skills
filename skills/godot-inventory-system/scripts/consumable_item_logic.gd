# consumable_item_logic.gd
# Extensible item behavior via inheritance
class_name PotionItem extends InventoryItem

@export var heal_amount: int = 50

func use(actor: Node) -> void:
	if actor.has_method("heal"):
		actor.heal(heal_amount)
		print("Used potion: Healed ", heal_amount)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — consumables that trigger abilities/effects
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — potions/food that modify stats
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
