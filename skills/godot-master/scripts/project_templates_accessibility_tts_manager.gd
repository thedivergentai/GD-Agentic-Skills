class_name AccessibilityTTSManager
extends Node

## Accessibility & Localization foundation for modern templates.
## Utilizes DisplayServer for native TTS and TranslationServer for i18n context.

func speak_ui_element(text: String, context: StringName = &"") -> void:
	# Use context to ensure the correct translation (e.g. "Lead" metal vs "Lead" action)
	var translated := TranslationServer.translate(text, context)
	
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
		
	# Trigger system-level screen reader / TTS
	var voices = DisplayServer.tts_get_voices()
	if not voices.is_empty():
		DisplayServer.tts_speak(translated, voices[0]["id"])

## Tool tip for templates: Use 'set_input_as_handled' in accessibility overlays.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html
# - https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — speak focused Control labels from menus/HUD
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — Autoload placement for accessibility services
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
