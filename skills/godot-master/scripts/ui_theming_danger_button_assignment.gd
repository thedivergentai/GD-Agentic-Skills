# danger_button_assignment.gd
# Using Theme Variations to create specialized styles without custom scenes [12]
extends Button

func _ready() -> void:
	# Assigning a StringName tells the node to look for this variation
	# in the active Theme. If found, it uses those overrides; otherwise,
	# it falls back to the base "Button" style.
	theme_type_variation = &"DangerButton"
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
