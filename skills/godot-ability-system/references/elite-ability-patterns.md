# Elite Ability Patterns (load on demand)

> **MANDATORY** when implementing combos, charge abilities, skill trees, status DoTs, or networked casts beyond Golden Path scripts. Do not paste these into SKILL.md or scenes from memory.

## Cooldown strategies

| Strategy | When | Notes |
|----------|------|-------|
| Per-ability | Default | Independent timers per `ability_id` — see [ability_manager.gd](../scripts/ability_manager.gd) |
| Global cooldown (GCD) | Anti-spam hotbars | 0.5–1.5s shared lock after any cast |
| Shared family cooldown | Hearthstone-style summons | One timer blocks all abilities in a tag group |
| Charge recharge | Mobility spells | [charge_ability.gd](../scripts/charge_ability.gd) — tick in `_physics_process` |

## Status effects — duplicate trap

> **CAUTION:** Applying a status template without `duplicate(true)` mutates the shared `.tres` for every character. Always append `effect_template.duplicate(true)` in [status_effect_manager.gd](../scripts/status_effect_manager.gd).

Tick `process_tick` on the **physics step** via the manager's `_physics_process`, not `_process`, so DoT timing stays deterministic under frame spikes.

## Cooldown persistence (save/load)

**WHY absolute end timestamps:** Saving raw `remaining_time` floats lets players roll back the clock or reload to wipe cooldowns.

```gdscript
# Save: ability_id -> unix_time_when_cooldown_ends
data[ability_id] = Time.get_unix_time_from_system() + remaining

# Load:
remaining = max(0.0, data[ability_id] - Time.get_unix_time_from_system())
```

## Animation lock

Gate `can_use` while `is_casting` or attack animations play. Wire `AnimationPlayer.animation_started/finished` to flip `is_casting` — interrupting mid-cast without `on_cancel()` refunds causes desync.

## Combo chains

[combo_tracker.gd](../scripts/combo_tracker.gd) — windowed sequences; finisher abilities stay normal `AbilityResource` entries granted only via `combo_triggered` signal.

## Skill tree architecture

- **Progression data:** [skill_node.gd](../scripts/skill_node.gd) + [skill_tree_manager.gd](../scripts/skill_tree_manager.gd) — duplicate templates per player save.
- **Combat casts:** Scene-scoped [ability_manager.gd](../scripts/ability_manager.gd) on the caster — skill tree grants Resources; never `get_node("/root/AbilityManager")` for combat.
- **Design-time graphs:** `@tool` GraphEdit visualizer for prerequisite auditing (optional editor script).

## Networking

[ability_caster_network.gd](../scripts/ability_caster_network.gd) — client predicts VFX/audio immediately; server validates costs and emits confirm/cancel RPCs. Server wins on mismatch.

## Object pooling policy

GDScript refcounting makes pools optional for light VFX. **Do** pool when profiler shows allocation spikes from high-frequency projectiles/AoE spawn/despawn.
