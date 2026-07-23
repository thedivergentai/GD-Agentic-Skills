# remote_debug_console.gd
# Real-time command console for mobile/deployed builds
extends CanvasLayer

# EXPERT NOTE: Remote builds don't show the Terminal. 
# A custom UI console allows running commands on-device.

@onready var line_edit = $LineEdit

func _on_text_submitted(cmd: String):
	match cmd:
		"noclip": _toggle_noclip()
		"gold": _add_gold(1000)
	line_edit.clear()

func _toggle_noclip(): pass
func _add_gold(_amt: int): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/debugger_panel.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — on-device console when no terminal
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — debug consoles in device exports
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
