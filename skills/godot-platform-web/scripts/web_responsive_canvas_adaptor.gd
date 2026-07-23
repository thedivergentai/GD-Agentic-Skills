class_name WebResponsiveCanvasAdaptor
extends Node

## Expert canvas resize management for responsive web games.
## Dynamically updates the HTML canvas size via JavaScriptBridge.

func _ready() -> void:
	get_window().size_changed.connect(_update_canvas_size)

func _update_canvas_size() -> void:
	if not OS.has_feature("web"): return
	
	# Force browser canvas to match window inner dimensions
	JavaScriptBridge.eval("""
		var canvas = document.getElementById('canvas');
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
	""")

## Tip: Set 'Stretch Mode' to 'canvas_items' and 'Aspect' to 'expand' in Project Settings.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/customizing_html5_shell.html
# - https://docs.godotengine.org/en/stable/classes/class_viewport.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — Control layout under canvas resize
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — stretch mode + content scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
