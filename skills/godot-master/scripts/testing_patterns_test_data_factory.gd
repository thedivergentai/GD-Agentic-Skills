# test_data_factory.gd
# Generating mock game data for testing
class_name TestDataFactory extends Object

# EXPERT NOTE: Centralizing data generation makes tests 
# cleaner and easier to update when schemas change.

static func create_maxed_player() -> Player:
	var p = Player.new()
	p.hp = 999
	p.str = 99
	return p
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — schema-compliant fixture Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — maxed stats fixtures for combat/RPG tests
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
