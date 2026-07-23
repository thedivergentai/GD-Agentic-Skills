# crisp_ui_scaler.gd
# Resolution-independent UI scaling via content_scale_factor [18]
extends Node

func _ready() -> void:
	get_tree().root.size_changed.connect(_update_ui_scale)

func _update_ui_scale() -> void:
	var window_size := get_tree().root.size
	# Baseline is 1080p.
	# Scaling the factor instead of node.scale keeps fonts and styleboxes 
	# crisp and pixel-perfect at any resolution.
	var factor: float = window_size.y / 1080.0
	get_tree().root.content_scale_factor = factor
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_theme.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — layout before skin polish
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md — seasonal Theme overlays
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md
# =============================================================================
