# property_watcher_gizmo.gd
# Monitoring variables without print spam
extends Node

# EXPERT NOTE: Use a label or custom gizmo to track 
# fast-changing variables (velocity, state) visually.

@onready var label = $DebugLabel

func _process(_delta):
	var parent = get_parent()
	if parent:
		label.text = "State: %s\nVel: %s" % [parent.state, parent.velocity]
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/output_panel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — property setters without print spam
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — Label overlays for live values
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
