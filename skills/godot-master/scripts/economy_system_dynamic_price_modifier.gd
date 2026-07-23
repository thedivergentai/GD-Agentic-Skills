# dynamic_price_modifier.gd
# Adjusting costs based on world state
extends Resource

# EXPERT NOTE: Injecting price modifiers allows for "Sale" events 
# or "Charisma" discounts without touching core item data.

@export var multiplier: float = 1.0

func calculate_price(base_price: int) -> int:
	return roundi(base_price * multiplier)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — charisma/reputation multipliers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — inject modifiers without mutating base
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
