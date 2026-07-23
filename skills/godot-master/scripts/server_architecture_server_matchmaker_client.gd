class_name ServerMatchmakerClient
extends Node

## Client-side logic for connecting to a central Load Balancer/Matchmaker.
## Uses HTTP to receive a dedicated server IP/Port handoff.

@export var matchmaker_url: String = "https://api.game.com/v1/match"
@export var auth_token: String = ""

signal match_found(ip: String, port: int)
signal match_failed(reason: String)

var _http: HTTPRequest

func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)

## Requests a server assignment from the Load Balancer.
func request_match(region: String = "us-east") -> void:
	var headers = ["Content-Type: application/json"]
	if not auth_token.is_empty():
		headers.append("Authorization: Bearer " + auth_token)
	
	var body = JSON.stringify({"region": region})
	_http.request(matchmaker_url, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		match_failed.emit("HTTP Error: %d" % response_code)
		return
	
	var json = JSON.new()
	var err = json.parse(body.get_string_from_utf8())
	if err != OK:
		match_failed.emit("JSON Parse Error")
		return
		
	var data = json.get_data()
	if data.has("ip") and data.has("port"):
		match_found.emit(data.ip, int(data.port))
	else:
		match_failed.emit("Malformed matchmaker response")

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/http_client_class.html
# - https://docs.godotengine.org/en/stable/classes/class_httprequest.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/ssl_certificates.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — connect ENet/WebSocket after matchmaker handoff
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md — HTTPS matchmaker from browser builds
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
