# web_json_rpc_bridge.gd
extends Node
class_name WebJsonRpcBridge

## Structured JSON-RPC between Godot and the browser page.
## Keep _js_callback alive on this node for the session.

var _json_rpc := JSONRPC.new()
var _js_callback: JavaScriptObject


func _ready() -> void:
	if not OS.has_feature("web"):
		return
	_json_rpc.set_method(&"update_score", _on_score_update)
	_js_callback = JavaScriptBridge.create_callback(_on_js_message)
	var window := JavaScriptBridge.get_interface("window")
	window.sendToGodot = _js_callback


func _on_js_message(args: Array) -> void:
	if args.is_empty():
		return
	var parsed: Variant = JSON.parse_string(str(args[0]))
	if parsed is Dictionary:
		var response = _json_rpc.process_action(parsed)
		if response:
			_send_to_browser(JSON.stringify(response))


func _on_score_update(params: Variant) -> Variant:
	# Extend with game-specific RPC handlers.
	return {"status": "ok", "params": params}


func _send_to_browser(json_str: String) -> void:
	var escaped := json_str.json_escape()
	var js := "if (window.onGodotMessage) { window.onGodotMessage('%s'); }" % escaped
	JavaScriptBridge.eval(js)
