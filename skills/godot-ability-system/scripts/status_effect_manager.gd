extends Node
class_name StatusEffectManager

## Owns per-entity ticking status effects. Tick from _physics_process — not _process.

var active_effects: Array[StatusEffect] = []


func add_effect(effect_template: StatusEffect) -> void:
	# CAUTION: duplicate(true) — mutating a shared .tres poisons every character using that template.
	active_effects.append(effect_template.duplicate(true))


func _physics_process(delta: float) -> void:
	for i: int in range(active_effects.size() - 1, -1, -1):
		var effect: StatusEffect = active_effects[i]
		if effect.process_tick(get_parent(), delta):
			active_effects.remove_at(i)
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — deep copy on apply
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — Cooldown & Status Timing Contract
# ---
