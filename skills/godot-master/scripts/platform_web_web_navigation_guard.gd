class_name WebNavigationGuard
extends Node

## Expert navigation guard for web games with unsaved state.
## Triggers a browser confirmation dialog if the user tries to close the tab.

func set_unsaved_changes(has_changes: bool) -> void:
	if not OS.has_feature("web"): return
	
	if has_changes:
		JavaScriptBridge.eval("""
			window.onbeforeunload = function() {
				return "You have unsaved changes. Are you sure you want to leave?";
			};
		""")
	else:
		JavaScriptBridge.eval("window.onbeforeunload = null;")

## Rule: Only enable this during active gameplay or editing sessions.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — flush saves before unload
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — toggle beforeunload from game state
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
