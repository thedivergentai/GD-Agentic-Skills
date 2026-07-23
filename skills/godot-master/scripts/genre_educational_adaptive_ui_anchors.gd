# adaptive_ui_anchors.gd
# Managing UI scaling across different screen factors
extends Control

# EXPERT NOTE: Anchoring is essential for educational apps 
# that must run on tablets (Landscape) and phones (Portrait).

func _ready():
	# Programmatic anchoring for dynamic UI generation
	anchor_left = 0.5
	anchor_right = 0.5
	offset_left = -200
	offset_right = 200 # Centered 400px panel
	grow_horizontal = GROW_DIRECTION_BOTH
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — prefer containers over raw anchors when possible
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — scale-aware theme constants
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — stretch mode / window size defaults
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
