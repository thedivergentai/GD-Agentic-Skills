class_name OrientationLayoutAdaptor
extends Node

## Expert adaptive orientation handler.
## Swaps UI layouts dynamically when the device is rotated.

@export var landscape_root: Control
@export var portrait_root: Control

func _ready() -> void:
	get_viewport().size_changed.connect(_on_screen_resized)
	_on_screen_resized()

func _on_screen_resized() -> void:
	var size := DisplayServer.screen_get_size()
	var is_portrait := size.y > size.x
	
	if landscape_root: landscape_root.visible = not is_portrait
	if portrait_root: portrait_root.visible = is_portrait

## Tip: Use separate CanvasLayers for Landscape/Portrait roots for easier design.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — landscape/portrait root layouts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — content-scale pairing on rotate
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
