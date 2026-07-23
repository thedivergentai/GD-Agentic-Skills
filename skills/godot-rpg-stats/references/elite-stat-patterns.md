# Elite RPG Stat Patterns (load on demand)

> **MANDATORY** for caps, derived-stat graphs, equipment tooltips, and damage formulas beyond [stats_component_reactive.gd](../scripts/stats_component_reactive.gd). Do not paste beginner `class_name Stats` tutorials.

## Core stats Resource (baseline reference)

Runtime characters use **StatsComponent** + duplicated templates — not a monolithic inline `Stats` class. See decision tree in SKILL.md.

## Equipment modifier registration

```gdscript
func on_equip(stats: StatsComponent, item_id: StringName) -> void:
    for stat_name in stat_bonuses:
        stats.add_modifier(stat_name, &"equipment_%s" % item_id, stat_bonuses[stat_name])

func on_unequip(stats: StatsComponent, item_id: StringName) -> void:
    for stat_name in stat_bonuses:
        stats.remove_modifier(stat_name, &"equipment_%s" % item_id)
```

Unique modifier keys required — [stat_modifier_stacking.gd](../scripts/stat_modifier_stacking.gd).

## Status effects via StatusEffectData

Use `Type.ADDITIVE | MULTIPLICATIVE | OVERRIDE` — never ad-hoc Dictionary stacks. Strip runtime buffs before [persistent_character_stats.gd](../scripts/persistent_character_stats.gd) save.

## Damage formula (centralized)

```gdscript
func calculate_damage(attacker: StatsComponent, defender: StatsComponent) -> float:
    var base_damage := float(attacker.get_stat(&"attack_power"))
    var defense := float(defender.get_stat(&"defense"))
    var damage := base_damage * (100.0 / (100.0 + defense))
    if randf() < attacker.get_stat(&"critical_chance"):
        damage *= 2.0
    return maxf(damage, 1.0)
```

**MANDATORY** [damage_formula_handler.gd](../scripts/damage_formula_handler.gd) for shared Player/NPC math.

## Elite: stat caps

[rpg_stat_resource.gd](../scripts/rpg_stat_resource.gd) — clamp in setter; emit `stat_changed` for UI.

## Elite: derived stat dependency graph

[derived_stat_resource.gd](../scripts/derived_stat_resource.gd) — recalc when base `stat_changed` fires; never poll `_process`.

## Elite: equipment comparison tooltip

[equipment_tooltip_helper.gd](../scripts/equipment_tooltip_helper.gd) — `_make_custom_tooltip` with BBCode diff vs equipped item.

## Skill requirements

```gdscript
func can_use(stats: StatsComponent) -> bool:
    if stats.level < required_level:
        return false
    for stat_name in required_stats:
        if stats.get_stat(stat_name) < required_stats[stat_name]:
            return false
    return true
```

## XP curve caution

Uncapped `pow()` on `experience_to_next_level` soft-locks or overflows — cap growth in [exp_progression_resource.gd](../scripts/exp_progression_resource.gd).

## Balance testing

Matrix-test modifier stacks with [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md).
