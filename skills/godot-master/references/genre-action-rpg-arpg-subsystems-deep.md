# ARPG Subsystems Deep-Dive (load on demand)

> **MANDATORY** when wiring combat formulas, loot affixes, equipment slots, or area scaling beyond the script catalog. Peer skills own full inventory/ability tutorials — route there after this reference.

## Combat damage (diminishing armor)

**WHY not linear armor:** `armor / (armor + K)` caps reduction — linear stacking to 100% creates invincible tanks.

Implementation: [combat_damage_calculator.gd](../scripts/genre_action_rpg_combat_damage_calculator.gd) + [stat_reduction_solver.gd](../scripts/genre_action_rpg_stat_reduction_solver.gd).

Hit resolve stays in `_physics_process` via [hitbox_component.gd](../scripts/genre_action_rpg_hitbox_component.gd) — enable monitoring only on attack frames; guard multi-hit per swing with a `has_hit` array.

## Progression curve

Damage/HP scaling: `base * pow(1.15, level)` — linear curves flatten the power fantasy. XP to next level: `int(100 * pow(1.5, level - 1))`.

## Loot generation

[loot_generator.gd](../scripts/genre_action_rpg_loot_generator.gd) — weighted rarity table + magic-find bias on rare+. Affix count scales with rarity tier.

**Visual differentiation:** rarity beams via `RenderingServer.instance_geometry_set_shader_parameter` — avoid `material.duplicate()` storms (see Advanced ARPG Meta-Systems in SKILL.md).

## Equipment & stats

- Stats live in `Resource` containers ([character_stats_resource.gd](../scripts/genre_action_rpg_character_stats_resource.gd)) — recalculate **only** on equip/level/buff change, never every frame.
- `duplicate(true)` at spawn: [deep_stat_duplicator.gd](../scripts/genre_action_rpg_deep_stat_duplicator.gd) / [entity_stat_duplicator.gd](../scripts/genre_action_rpg_entity_stat_duplicator.gd).
- Equipment applies flat then percent modifiers, then calls `recalculate_stats()`.

## Ability / skill-tree glue

Hotbar abilities → [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md). Skill-tree unlocks grant `AbilityResource` to the **caster's** scene manager — not a global combat Autoload.

## Enemy scaling

[enemy_area_scaler.gd](../scripts/genre_action_rpg_enemy_area_scaler.gd) — `level_mult = 1 + (area_level - 1) * 0.15` on vitality/strength and XP reward.

## Architecture overview

```
Progression Autoloads (catalog only)     Scene entities
├── unlock flags / quest state           ├── CharacterBody + components
└── loot tables (data)                   ├── HealthComponent / Hitbox
                                         ├── scene AbilityManager
                                         └── RPGStats Resource (duplicated)
```

Signals up, calls down — HUD observes; never treat UI SceneTree as inventory truth ([threaded_inventory_loader.gd](../scripts/genre_action_rpg_threaded_inventory_loader.gd) for heavy parses).

## Common pitfalls

| Pitfall | Fix |
|---------|-----|
| Floaty combat | Hit recovery/stagger 0.2–0.5s — [telegraphed_enemy.gd](../scripts/genre_action_rpg_telegraphed_enemy.gd) |
| Identical loot | Rarity color beams + distinct SFX |
| Boss spaghetti AI | [hierarchical_state_base.gd](../scripts/genre_action_rpg_hierarchical_state_base.gd) |
| Late-game bag hitch | WorkerThreadPool — threaded_inventory_loader |
| AnimationTree flip | Explicit bool Advance Conditions — animation_condition_sync |

## Reference titles

Diablo / PoE (loot), Elden Ring / Souls (combat telegraphs), Hades (ability cadence), Grim Dawn (build depth).
