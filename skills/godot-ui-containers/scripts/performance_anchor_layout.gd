# performance_anchor_layout.gd
# Optimization: Replacing heavy nested containers with Anchor Layouts [16]
extends Control

# EXPERT NOTE: 10 levels of nested Containers (Margin > VBox > HBox) 
# cause massive recount/layout spikes. Use Anchors for static padding.

func setup_responsive_padding(padding: float = 20.0) -> void:
	# Full rect anchor
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Manual offsets act as responsive margins without the overhead 
	# of a MarginContainer node.
	offset_left = padding
	offset_top = padding
	offset_right = -padding
	offset_bottom = -padding
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — shallow trees vs deep Margin stacks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — safe-area padding via offsets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
