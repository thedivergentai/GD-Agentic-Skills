class_name CompHitboxComponent
extends Area2D

## Expert Hitbox Component.
## Maps physical collision to a HealthComponent.

@export var health_component: CompHealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage_amount"):
		health_component.damage(area.get_damage_amount())

## Rule: Use '@export' to link components in the inspector, never 'get_node'.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — export-linked hit→health bridge
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — damage payloads into modular health
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
