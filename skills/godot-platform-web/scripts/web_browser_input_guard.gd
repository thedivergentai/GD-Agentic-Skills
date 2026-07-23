class_name WebBrowserInputGuard
extends Node

## Expert input guard to prevent browser default behaviors.
## Disables context menu (right-click) and spacebar scrolling.

func _ready() -> void:
	if not OS.has_feature("web"): return
	
	JavaScriptBridge.eval("""
		window.addEventListener('contextmenu', e => e.preventDefault());
		window.addEventListener('keydown', function(e) {
			if([32, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
				e.preventDefault();
			}
		}, false);
	""")

## Rule: Only disable defaults if your game fully handles these inputs.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — own game inputs before preventDefault
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — mobile browser gesture conflicts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
