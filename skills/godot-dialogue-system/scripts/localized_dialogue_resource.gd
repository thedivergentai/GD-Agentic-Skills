# localized_dialogue_resource.gd
# Professional localization strategy
extends DialogueResource

# EXPERT NOTE: Store translation keys in nodes instead 
# of raw text to support multiple languages via .csv files.

func get_node_text(node_id: String) -> String:
	var node = nodes[node_id]
	return tr(node.text_key)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_spreadsheets.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html
# - https://docs.godotengine.org/en/stable/classes/class_translationserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — keys on Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — locale project settings
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
