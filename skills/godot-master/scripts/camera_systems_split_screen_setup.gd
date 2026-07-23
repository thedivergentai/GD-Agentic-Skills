# split_screen_setup.gd
# Managing dynamic split-screen viewports efficiently [146]
extends HBoxContainer

# Scene Structure:
# HBoxContainer
#   ├─ SubViewportContainer (Player 1)
#   │   └─ SubViewport
#   │       └─ Camera2D
#   └─ SubViewportContainer (Player 2)
#       └─ SubViewport
#           └─ Camera2D

func set_split_ratio(ratio: float) -> void:
	# Custom weight management for asymmetric split-screen
	var p1 = get_child(0) as Control
	var p2 = get_child(1) as Control
	
	p1.size_flags_stretch_ratio = ratio
	p2.size_flags_stretch_ratio = 1.0 - ratio

func _ready() -> void:
	# Ensure audio listeners are balanced
	get_child(0).get_node("SubViewport").audio_listener_enable_2d = true
	get_child(1).get_node("SubViewport").audio_listener_enable_2d = false
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_hsplitcontainer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — local coop camera ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — stretch ratios for asymmetric splits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — dual SubViewport cost budgets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — which viewport owns the 2D audio listener
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
