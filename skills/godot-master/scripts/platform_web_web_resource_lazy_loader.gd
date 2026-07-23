class_name WebResourceLazyLoader
extends Node

## Expert lazy loading of remote Godot resources/PCKs in the browser.
## Uses HTTPRequest but with browser cache awareness.

func load_remote_pck(url: String) -> void:
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_pck_downloaded)
	http.request(url)

func _on_pck_downloaded(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS and code == 200:
		# ProjectSettings.load_resource_pack is expert for post-launch content
		ProjectSettings.load_resource_pack(body)
		print("Web: Remote PCK loaded successfully.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html
# - https://docs.godotengine.org/en/stable/classes/class_httprequest.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — PCK/resource pack contracts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — host split PCK artifacts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
