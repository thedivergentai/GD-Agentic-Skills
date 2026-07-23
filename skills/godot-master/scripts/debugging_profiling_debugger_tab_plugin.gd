# debugger_tab_plugin.gd
# Injecting custom visual tabs into the bottom Debugger panel
@tool
extends EditorDebuggerPlugin

# EXPERT NOTE: This must be registered via an EditorPlugin 
# to take effect in the Godot Editor UI.

func _setup_session(session_id: int):
	var panel := VBoxContainer.new()
	panel.name = "MyTools"
	
	var label := Label.new()
	label.text = "Custom Debug Info"
	panel.add_child(label)
	
	var session := get_session(session_id)
	session.add_session_tab(panel)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_editordebuggerplugin.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/debugger_panel.html
# - https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — EditorPlugin registration layout
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — avoid Autoload-only debugger hooks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
