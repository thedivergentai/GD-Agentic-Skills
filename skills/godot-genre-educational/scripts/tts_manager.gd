# tts_manager.gd
# Utilizing Godot's built-in Text-to-Speech for accessibility
extends Node

# EXPERT NOTE: DisplayServer.tts_spoke() provides native 
# OS-level accessibility support for visually impaired students.

func speak_question(text: String):
	var voices = DisplayServer.tts_get_voices_for_language("en")
	if !voices.is_empty():
		DisplayServer.tts_speak(text, voices[0])

func stop_speech():
	DisplayServer.tts_stop()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — consent toggle + accessibility input
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — speak visible prompt text
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — OS TTS availability assumptions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
