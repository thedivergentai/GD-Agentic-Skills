class_name NativeShareInvoker
extends Node

## Expert OS-level sharing for Mobile.
## Proxies to native share sheets for text and images.

func share_text(text: String, title: String = "Share My Score") -> void:
	if OS.has_feature("android") or OS.has_feature("ios"):
		# Requires a native plugin (e.g., 'GodotShare')
		# This boilerplate shows the typical API call
		if Engine.has_singleton("GodotShare"):
			Engine.get_singleton("GodotShare").shareText(title, "Checkout my score!", text)
	else:
		print("Mobile: Native share only available on mobile devices.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/ios/ios_plugin.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — ship native share plugins in presets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — optional share singleton
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
