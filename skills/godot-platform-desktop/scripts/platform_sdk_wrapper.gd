class_name PlatformSDKWrapper
extends Node

## Expert wrapper for proprietary PC SDKs (Steam, Epic).
## Uses safety checks to prevent crashes when singletons are missing.

var _steam_api: Object = null

func _ready() -> void:
	if Engine.has_singleton("Steam"):
		_steam_api = Engine.get_singleton("Steam")
		var init = _steam_api.steamInit()
		if init.status == 1:
			print("Desktop: Steamworks Initialized.")
	else:
		print("Desktop: No Steam singleton found. Running in standalone mode.")

func unlock_achievement(id: String) -> void:
	if _steam_api and _steam_api.isSteamRunning():
		_steam_api.setAchievement(id)
		_steam_api.storeStats()

## Expert: Always check 'Engine.has_singleton' before any SDK call.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — store builds with Steam/Epic plugins
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — SDK wrapper as autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
