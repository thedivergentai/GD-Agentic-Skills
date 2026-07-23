class_name ExportFeatureFlagManager
extends Node

## Expert runtime Feature Flag management.
## Swaps logic/API endpoints based on build features.

func is_debug() -> bool:
	return OS.has_feature("debug")

func is_release() -> bool:
	return OS.has_feature("release")

func is_mobile() -> bool:
	return OS.has_feature("mobile")

func get_api_endpoint() -> String:
	if is_debug():
		return "https://dev.api.game.com"
	return "https://api.game.com"

## Rule: Never hardcode 'is_debug' flags. Rely on Godot's built-in feature flags.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — mobile feature tag branches
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — strip debug-only tools via release tag
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
