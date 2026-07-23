# match_state_resetter.gd
# Cleaning up temporary match buffs on resources
extends Node

# EXPERT NOTE: Implement a reset on resources to ensure 
# match-only buffs don't persist in the .tres files.

func reset_card_collection(collection: Array[CardData]):
	for card in collection:
		# Custom logic to restore base values
		card.update_stats(card.get("base_atk"), card.get("base_hp"))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — reset/duplication so .tres stay pristine
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist collection, never in-match buffs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
