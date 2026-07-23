class_name WebJavaScriptBridgeCallback
extends Node

## Expert two-way communication between GDScript and JavaScript.
## Demonstrates create_callback for receiving async data from browser APIs.

func _ready() -> void:
	if not OS.has_feature("web"): return
	
	# Create a persistent callback to JS
	var js_callback := JavaScriptBridge.create_callback(_on_js_called)
	
	# Pass the callback to a JS function (e.g., a custom analytic or login hook)
	var window := JavaScriptBridge.get_interface("window")
	if window:
		window.registerGodotCallback(js_callback)

func _on_js_called(args: Array) -> void:
	var message = args[0]
	print("Web: Received message from JavaScript: ", message)

## Rule: Always keep a reference to 'js_callback' to prevent garbage collection.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptobject.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — keep create_callback refs on Autoload
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — browser message bridges for online hooks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
