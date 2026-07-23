# dynamic_localization.gd
# Transitioning between languages at runtime using tr()
extends Node

# EXPERT NOTE: tr() and atr() allow for dynamic localization 
# without restarting the application.

func update_language(locale: String):
	TranslationServer.set_locale(locale)
	_refresh_ui_text()

func _refresh_ui_text():
	# Example for a button tag
	# get_node("StartButton").text = tr("KEY_START")
	pass

func get_apples_text(count: int) -> String:
	# EXPERT: Pluralization support via TranslationServer
	return atr_n("APPLE_COUNT_ONE", "APPLE_COUNT_MANY", count)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_gettext.html
# - https://docs.godotengine.org/en/stable/classes/class_translationserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — refresh BBCode after locale change
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — font fallbacks per locale
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist student language preference
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
