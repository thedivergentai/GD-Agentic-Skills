# responsive_inventory_grid.gd
# Auto-adjusting GridContainer columns based on available width [10]
extends GridContainer

@export var item_min_width: float = 64.0

func _ready() -> void:
	# Recalculate layout whenever the window or container resizes
	resized.connect(_on_resized)

func _on_resized() -> void:
	var h_sep := get_theme_constant("h_separation")
	var available_width := size.x
	
	# Compute max columns that fit without manual overflow
	var max_cols := maxi(1, int((available_width + h_sep) / (item_min_width + h_sep)))
	columns = max_cols
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_gridcontainer.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — slot data vs column layout ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — h_separation theme constant
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
