# localized_quest_description.gd
# Strategy for translation-friendly quest text
extends Resource

# EXPERT NOTE: Use 'tr()' on IDs rather than hardcoding strings 
# inside the Resource files for professional localization support.

@export var title_key: String = "QUEST_01_TITLE"
@export var desc_key: String = "QUEST_01_DESC"

func get_title() -> String:
	return tr(title_key)

func get_desc() -> String:
	return tr(desc_key)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_spreadsheets.html
# - https://docs.godotengine.org/en/stable/classes/class_translationserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — store translation keys on Resources, not hardcoded strings
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — journal UI calls get_title()/get_desc() after locale change
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
