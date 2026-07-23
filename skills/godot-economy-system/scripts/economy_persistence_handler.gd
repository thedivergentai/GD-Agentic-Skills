# economy_persistence_handler.gd
# Saving financial state securely
extends Node

# EXPERT NOTE: Save balances as a simple JSON-compatible dictionary. 
# Consider basic encryption for premium currency counts.

func save_economy() -> Dictionary:
	return WalletManager.balances.duplicate()

func load_economy(data: Dictionary):
	WalletManager.balances = data
	for id in data:
		WalletManager.balance_changed.emit(id, data[id])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# - https://docs.godotengine.org/en/stable/classes/class_dictionary.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — plug wallet blob into save schema
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — restore Autoload balances on load
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
