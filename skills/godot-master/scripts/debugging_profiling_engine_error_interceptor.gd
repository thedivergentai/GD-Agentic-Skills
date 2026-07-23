# engine_error_interceptor.gd
# Piping C++ engine errors to custom logging backends
extends Node

# EXPERT NOTE: register_message_capture allows you to intercept
# underlying engine errors that usually only go to the console.

func _ready():
	if OS.is_debug_build():
		EngineDebugger.register_message_capture("custom_logger", _on_engine_error)

func _on_engine_error(message: String, data: Array) -> bool:
	# Process or send error data to external analytics
	print_rich("[color=orange]Intercepted Engine Error:[/color] ", message)
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/output_panel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — global error capture Autoload
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — server-side analytics sinks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
