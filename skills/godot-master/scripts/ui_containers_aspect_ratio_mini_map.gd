# aspect_ratio_mini_map.gd
# Enforcing aspect ratios for UI elements across window resizes [12]
extends AspectRatioContainer

func _ready() -> void:
	# Forces a 1:1 square for a mini-map
	ratio = 1.0
	# STRETCH_FIT: Scales the child as large as possible without clipping
	stretch_mode = AspectRatioContainer.STRETCH_FIT
	alignment_horizontal = AspectRatioContainer.ALIGNMENT_CENTER
	alignment_vertical = AspectRatioContainer.ALIGNMENT_CENTER
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_aspectratiocontainer.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — minimap camera feed sizing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — keep 1:1 under aspect changes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
