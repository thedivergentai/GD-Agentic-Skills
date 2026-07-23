class_name SecondaryWindowSpawner
extends Node

## Expert multi-window support for tools or secondary displays.
## Requires 'display/window/subwindows/embed_subwindows' to be set to false.

func spawn_floating_window(scene: PackedScene, title: String = "Tool") -> Window:
	var window := Window.new()
	window.title = title
	window.wrap_controls = true
	window.transient = false # Allow it to be moved to other monitors
	
	var ui := scene.instantiate()
	window.add_child(ui)
	
	add_child(window)
	window.popup_centered(Vector2i(800, 600))
	return window

## Rule: Multi-window is best for desktop productivity or local-multiplayer status screens.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_window.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/creating_applications.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — floating tool windows
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — content inside secondary Windows
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
