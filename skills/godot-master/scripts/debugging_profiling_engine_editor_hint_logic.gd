# engine_editor_hint_logic.gd
# Debug tools that run inside the Editor
@tool
extends Node3D

# EXPERT NOTE: Use Engine.is_editor_hint() to run 
# visualization tools safely while designing.

func _process(_delta):
	if Engine.is_editor_hint():
		# Update gizmo or helper mesh in real-time
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — @tool script project layout
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — editor-time visualization gizmos
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
