# deck_builder_validator.gd
# Enforcing rules during card collection management
extends Node

# EXPERT NOTE: Use for validating "Max 3 copies of a card" 
# or "Total mana curve" constraints.

func is_deck_valid(deck: Array[CardData]) -> bool:
	if deck.size() != 30: return false
	
	var counts = {}
	for card in deck:
		counts[card.card_name] = counts.get(card.card_name, 0) + 1
		if counts[card.card_name] > 2: return false # Duplicate limit
	
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — owned-card collection feeding builder rules
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — validate mana curves against sim win-rates
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — pack/shop costs that constrain deck construction
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
