# buff_stat.gd
# Resource-Driven Buff System
# By extending Resource and using class_name, you can create highly modular, drag-and-drop ability data.
class_name BuffStat extends Resource

@export var duration: float = 5.0
@export var damage_multiplier: float = 1.5
signal buff_expired

# In the ability logic node:
func apply_buff(target: Node, buff_data: BuffStat) -> void:
    if target.has_method("multiply_damage"):
        target.multiply_damage(buff_data.damage_multiplier)
        
        var timer := target.get_tree().create_timer(buff_data.duration)
        timer.timeout.connect(func(): target.multiply_damage(1.0 / buff_data.damage_multiplier))
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — buffs as drag-and-drop Resources
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — duplicate templates before mutating runtime state
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — duration via create_timer on target tree
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — damage_multiplier and modifier stacking
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — apply buffs inside hit/ability resolve
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — sim buff uptime vs raw damage
# ---
