class_name WebLocalStorageWrapper
extends Node

## Expert wrapper for browser localStorage.
## Features JSON serialization, feature gates, and quota-safe writes (no eval strings).

func save_data(key: String, value: Variant) -> bool:
	if not OS.has_feature("web"):
		return false

	var json_str := JSON.stringify(value)
	if json_str.is_empty() and value != null:
		push_error("WebLocalStorage: JSON.stringify failed.")
		return false

	var storage := JavaScriptBridge.get_interface("localStorage")
	if storage == null:
		push_error("WebLocalStorage: localStorage interface unavailable.")
		return false

	# QuotaExceededError surfaces as a failed JS call; detect via round-trip when possible.
	storage.setItem(key, json_str)
	var written: Variant = storage.getItem(key)
	if written == null:
		push_error("WebLocalStorage: Storage quota exceeded or blocked.")
		return false
	return true

func load_data(key: String) -> Variant:
	if not OS.has_feature("web"):
		return null

	var storage := JavaScriptBridge.get_interface("localStorage")
	if storage == null:
		return null

	var data: Variant = storage.getItem(key)
	if data == null:
		return null
	return JSON.parse_string(str(data))

## Rule: Browsers may wipe localStorage; never use it for mission-critical core data alone.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html
# - https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — quota-safe storage + cloud fallback
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — OS.has_feature("web") gates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
