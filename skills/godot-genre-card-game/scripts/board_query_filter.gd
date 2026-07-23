# board_query_filter.gd
# Using functional filtering to query card states
extends Node

# EXPERT NOTE: Array.filter() is highly efficient for 
# logic like "Find all Taunt cards with health > 2".

func find_taunters(board_cards: Array[Node]) -> Array[Node]:
	return board_cards.filter(func(card): 
		return card.get("is_taunt") == true and card.health > 2
	)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — filter/Callable board queries without index bugs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — keyword flags (Taunt) consumed by filters
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
