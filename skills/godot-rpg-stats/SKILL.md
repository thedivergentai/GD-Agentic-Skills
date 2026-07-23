---
name: godot-rpg-stats
description: "Expert blueprint for RPG stat systems (attributes, leveling, modifiers, damage formulas) using Resource-based stats, stackable modifiers, and derived stat calculations. Use when implementing character progression OR equipment/buff systems. Keywords stats, attributes, leveling, modifiers, CharacterStats, derived stats, damage calculation, XP."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# RPG Stats

Resource-based stats, modifier stacks, and derived calculations define flexible character progression.

## Available Scripts

> **MANDATORY** by scenario — read before implementing:
> - Templates / base attributes → [base_stats_resource.gd](scripts/base_stats_resource.gd)
> - Runtime stack + reactive recalc → [stats_component_reactive.gd](scripts/stats_component_reactive.gd) + [stat_modifier_stacking.gd](scripts/stat_modifier_stacking.gd)
> - Buff/debuff data → [status_effect_data.gd](scripts/status_effect_data.gd) (`Type.ADDITIVE` / `MULTIPLICATIVE` / `OVERRIDE`)
> - Combat math → [damage_formula_handler.gd](scripts/damage_formula_handler.gd)

### [base_stats_resource.gd](scripts/base_stats_resource.gd)
Core data container for base attributes (Str, Dex, Int) and derived scaling rules.

### [status_effect_data.gd](scripts/status_effect_data.gd)
Serialized buff/debuff definition using `StatusEffectData.Type` { ADDITIVE, MULTIPLICATIVE, OVERRIDE }.

### [stats_component_reactive.gd](scripts/stats_component_reactive.gd)
Orchestrator for JIT (Just-In-Time) stat calculation with active modifier stacking.

### [exp_progression_resource.gd](scripts/exp_progression_resource.gd)
Data-driven level-up curve definition using growth factors and base XP.

### [dynamic_stat_label_sync.gd](scripts/dynamic_stat_label_sync.gd)
Reactive UI hook for syncing Labels to stat changes without polling.

### [damage_formula_handler.gd](scripts/damage_formula_handler.gd)
Centralized RefCounted utility for complex combat math and damage calculations.

### [stat_modifier_stacking.gd](scripts/stat_modifier_stacking.gd)
Logic for handling unique vs. stackable buffs and refreshing durations.

### [resource_stat_inheritance.gd](scripts/resource_stat_inheritance.gd)
Pattern for extending base stats with specialized attributes (Elemental Resists).

### [persistent_character_stats.gd](scripts/persistent_character_stats.gd)
Managing the serialization of character progression to `.tres` files.

### [level_up_system.gd](scripts/level_up_system.gd)
Logic for awarding experience and triggering level-up benefits.

## NEVER Do in RPG Stats

- **NEVER use integers for percentages** — Always use `float` (0.0–1.0 or 0.0–100.0) to avoid truncation.
- **NEVER modify current_health without emitting signals** — UI desyncs without broadcasts.
- **NEVER rely solely on additive modifiers** — Use multiplicative or hybrid scaling for long progressions.
- **NEVER add modifiers without a unique ID or Key** — Required to remove specific effects.
- **NEVER use exponential XP formulas without a growth cap** — Uncapped `pow()` overflows or soft-locks levels.
- **NEVER forget to clamp derived values** — Negative vitality must not yield negative max HP (`maxi(val, 1)`).
- **NEVER perform heavy stat recalculations in `_process()`** — Recalc only on modifier/base change (reactive).
- **NEVER hardcode stat names in logic** — Use StringNames or enums.
- **NEVER store temporary runtime buffs in a permanent Save Resource** — Strip short-duration modifiers before serialize.
- **NEVER calculate damage directly in the Character script** — Centralize in [damage_formula_handler.gd](scripts/damage_formula_handler.gd).
- **NEVER invent Dictionary-only modifier APIs in examples** — Align with `StatusEffectData.Type` and the stacking scripts.

---

## Decision Tree

| Layer | Responsibility | Script |
|-------|----------------|--------|
| **Resource template** | Designer-authored base attributes, curves, inheritance | [base_stats_resource.gd](scripts/base_stats_resource.gd), [exp_progression_resource.gd](scripts/exp_progression_resource.gd), [resource_stat_inheritance.gd](scripts/resource_stat_inheritance.gd) |
| **Runtime StatsComponent** | Duplicate/instance template, apply/remove modifiers, emit signals, JIT derived stats | **MANDATORY** [stats_component_reactive.gd](scripts/stats_component_reactive.gd) + [stat_modifier_stacking.gd](scripts/stat_modifier_stacking.gd) |
| **StatusEffectData** | Typed buff rows (`ADDITIVE` / `MULTIPLICATIVE` / `OVERRIDE`) | [status_effect_data.gd](scripts/status_effect_data.gd) |
| **DamageFormula (RefCounted)** | Pure combat math shared by Player/NPC | **MANDATORY** [damage_formula_handler.gd](scripts/damage_formula_handler.gd) |
| **Persistence** | Save progression; strip runtime buffs first | [persistent_character_stats.gd](scripts/persistent_character_stats.gd) |
| **UI sync** | Labels listen to signals — no polling | [dynamic_stat_label_sync.gd](scripts/dynamic_stat_label_sync.gd) |

Do **not** paste beginner `class_name Stats` / Dictionary equipment tutorials — route to the scripts above.

---

## API alignment (StatusEffectData)

```gdscript
# Author buffs as Resources — not ad-hoc Dictionary modifiers
var haste := StatusEffectData.new()
haste.name = "Haste"
haste.type = StatusEffectData.Type.MULTIPLICATIVE
haste.attribute = "speed"
haste.value = 1.25
haste.duration = 8.0

var flat_str := StatusEffectData.new()
flat_str.type = StatusEffectData.Type.ADDITIVE
flat_str.attribute = "strength"
flat_str.value = 5.0

var break_def := StatusEffectData.new()
break_def.type = StatusEffectData.Type.OVERRIDE
break_def.attribute = "defense"
break_def.value = 0.0
```

Stacking / refresh / unique-vs-stackable behavior: **MANDATORY** [stat_modifier_stacking.gd](scripts/stat_modifier_stacking.gd). Apply through [stats_component_reactive.gd](scripts/stats_component_reactive.gd) so derived stats recalc once per change.

---

## Elite reminders (script-backed)

1. **Caps** — Clamp on setters; never allow overflow attributes.
2. **Dependency graphs** — Derived stats recalc from signals when bases change (reactive component), never `_process`.
3. **Equipment** — Register/remove modifier IDs on equip/unequip via the stacking API (peer inventory skill for item ownership).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — why base stats, curves, and status effects belong on `Resource` templates you duplicate or instance per character.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — `duplicate()`, `resource_local_to_scene`, and shared-vs-unique semantics that prevent every enemy sharing one HP Resource.
- [GDScript exported properties](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / `@export_group` so designers tune attributes and scaling in the Inspector without code edits.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — `stat_changed` / `stats_recalculated` so UI and derived stats react without `_process` polling.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — serialize progression Resources and strip runtime-only buffs before write.
- [File paths in Godot projects](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — `user://` vs `res://` for persistent character `.tres` saves.
- [ResourceSaver](https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html) — write character stats Resources to disk after level-ups.
- [ResourceLoader](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html) — `exists` / load paths when restoring progression on boot.
- [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html) — keep damage formulas and pure combat math off the scene tree.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — seeded crit / variance rolls that stay reproducible in balance tests.
- [Label](https://docs.godotengine.org/en/stable/classes/class_label.html) — bind text to signal-driven attribute refresh for HUD sync.
- [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html) — `create_timer` for timed buff expiry without a per-effect Node.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, Resources, and project layout before building CharacterStats assets.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed getters, setters, and signal wiring used by reactive stat components.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — inheritance, `.tres` templates, and composition patterns for attribute data.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — ownership and fan-out rules so `hp_changed` / `level_up` do not create UI cycles.

#### Complements
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — abilities that gate on level/attributes and apply temporary modifiers.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — equipment bonuses that register and remove modifier IDs on equip/unequip.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — hit resolution that consumes attack/defense/crit from this stack.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — full save pipelines around ResourceSaver of progression data.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — character sheets and tooltips that listen to recalculated stats.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — gold/XP sinks that couple with level curves and gear stat budgets.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — matrix-test power curves, modifier stacks, and damage variance before shipping numbers.

#### Downstream / consumers
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — ARPG builds that rely on attributes, gear mods, and derived combat stats.
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — run-scoped modifiers and scaling that reset between runs.
- [godot-turn-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md) — turn-based combat that resolves damage formulas from shared stats.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
