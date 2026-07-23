# skills/combat-system/scripts/hitbox_component.gd
extends Area3D

## Hitbox Component Expert Pattern
## Standardized damage delivery system working in tandem with HurtboxComponent.

class_name HitboxComponent

@export var damage := 10.0
@export var knockback_force := 5.0
@export var hit_stun_time := 0.2
@export_flags("Physical", "Fire", "Ice", "Lightning", "Poison")
var attack_types: int = 1  # DamageData.DamageType.PHYSICAL

# Optional: Team filtering (layer/mask is preferred, but this adds logic layer)
@export var team_index := 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitorable = true
	monitoring = true

func _on_area_entered(area: Area3D) -> void:
	if area is HurtboxComponent:
		if area.team_index != team_index:  # Prevent friendly fire
			var attack_data := DamageData.new()
			attack_data.amount = damage
			attack_data.knockback_force_3d = knockback_force
			attack_data.hit_stun_time = hit_stun_time
			attack_data.damage_types = attack_types
			attack_data.source_position = global_position
			attack_data.source = owner
			area.receive_hit(attack_data)

## EXPERT USAGE:
## 1. Add HitboxComponent to Weapon/Projectile
## 2. Set Collision Layer to 'Hitbox'
## 3. Set Collision Mask to 'Hurtbox'
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html — 3D HitboxComponent area_entered
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html — layer/mask team filtering
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — AttackData as transferable hit payload
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — HitboxComponent on weapon/projectile scenes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — elemental/team filters before receive_hit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — ability execute feeds AttackData fields
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md
# =============================================================================
