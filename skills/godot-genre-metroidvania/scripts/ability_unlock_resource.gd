class_name AbilityResource
extends Resource

## Expert Ability Logic (Godot 4.7).
## Resource-based ability definitions and fly-in UI logic.

@export var id: StringName = &"double_jump"
@export var name: String = "Double Jump"
@export var icon: Texture2D

func trigger_notification(ui_panel: Control) -> void:
	# Fly-in effect for discovery
	var t = ui_panel.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(ui_panel, "position:x", 20, 0.5)
	t.tween_interval(2.0)
	t.tween_property(ui_panel, "position:x", -300, 0.4)

## [SKILL NOTICE]: Use 'duplicate(true)' if abilities have mutable 
## power levels to prevent modifying the source .tres file.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — ability defs as Resource assets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — grant/unlock pipeline consuming this resource
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune unlock power/cost before ship
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
