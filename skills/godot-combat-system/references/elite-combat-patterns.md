# Elite Combat Patterns (load on demand)

> **MANDATORY** for combat telemetry, authoritative multiplayer damage, combo buffers, and in-game hitbox visualization. Golden path remains DamageData → HealthComponent → Hitbox.

## Combo buffers

[combo_system.gd](../scripts/combo_system.gd) — windowed `StringName` buffer; finishers stay normal attacks gated by `combo_executed`. Wire input via [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md), not `_input` hit logic.

## Combat state gating

[combat_state.gd](../scripts/combat_state.gd) — `can_act` blocks attack/dodge overlap. Prefer [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) when states multiply.

## Damage popups

[damage_popup.gd](../scripts/damage_popup.gd) — pool Labels in production; this script shows the tween + crit scale pattern.

## Combat telemetry

> **WHY batch JSON flushes:** Writing every hit to disk stalls combat. Batch ~10 events then flush to `user://combat_log.json`.

[combat_logger.gd](../scripts/combat_logger.gd)

## Authoritative networked damage

> **CAUTION:** Clients must never apply final damage locally in competitive multiplayer.

[networked_damage_manager.gd](../scripts/networked_damage_manager.gd) — `request_damage` → server validates → `client_confirm_hit`. Add lag-compensation / distance checks server-side.

## Hitbox visualization

[hitbox_visualizer.gd](../scripts/hitbox_visualizer.gd) — toggle `debug_collisions_hint`; color attack vs hurt volumes differently.

## Inline tutorials (moved — use scripts)

| Pattern | Script |
|---------|--------|
| DamageData payload | [damage_data.gd](../scripts/damage_data.gd) |
| Health + i-frames | [health_component.gd](../scripts/health_component.gd) |
| Area hit delivery | [hitbox_hurtbox.gd](../scripts/hitbox_hurtbox.gd) |
| AoE / hit-stop | [combat_system_patterns.gd](../scripts/combat_system_patterns.gd) |
| Abilities / cooldowns | [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) |

## Critical hits

Roll crit on `DamageData` construction before `take_damage` — keep crit math out of UI.

```gdscript
func calculate_damage(base_damage: float, crit_chance: float = 0.1) -> DamageData:
	var data := DamageData.new(base_damage)
	if randf() < crit_chance:
		data.is_critical = true
		data.amount *= 2.0
	return data
```
