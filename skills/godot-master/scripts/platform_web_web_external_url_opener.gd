class_name WebExternalURLOpener
extends Node

## Expert utility to open external URLs from a web export.
## Ensures 'noopener' and 'noreferrer' are used for security.

func open_url(url: String, new_tab: bool = true) -> void:
	if not OS.has_feature("web"):
		OS.shell_open(url)
		return
	
	var target := "_blank" if new_tab else "_self"
	JavaScriptBridge.eval("window.open('%s', '%s', 'noopener,noreferrer');" % [url, target])

## Rule: Most browsers block window.open unless triggered by a click/keypress.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — OS.shell_open fallback off-web
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — click-gated external link buttons
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
