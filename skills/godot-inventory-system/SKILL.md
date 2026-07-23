---
name: godot-inventory-system
description: "Expert blueprint for inventory systems (Diablo, Resident Evil, Minecraft) covering slot-based containers, stacking logic, weight limits, equipment systems, and drag-drop UI. Use when building RPG inventories, survival item management, or loot systems. Keywords inventory, slot, stack, equipment, crafting, item, Resource, drag-drop."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Inventory System

Resource-first slots, stacking, weight, equipment, and loot — **scripts are source of truth** (no duplicated Inventory/Equipment/Crafting dumps in this body).

## Scenario triggers (which script?)

| Scenario | Open |
|---|---|
| **Slot bag** (WoW-style stacks) | [inventory_data_resource.gd](scripts/inventory_data_resource.gd) + [item_slot_data.gd](scripts/item_slot_data.gd) + [inventory_ui_controller.gd](scripts/inventory_ui_controller.gd) |
| **Tetris grid** (Diablo/RE footprint) | [grid_inventory_logic.gd](scripts/grid_inventory_logic.gd) / [inventory_grid.gd](scripts/inventory_grid.gd) |
| **Equipment** | Item Resources + RPG stats complement; drag via [drag_and_drop_slot.gd](scripts/drag_and_drop_slot.gd) |
| **Loot table** | [loot_table_resource.gd](scripts/loot_table_resource.gd) + [item_pickup_node.gd](scripts/item_pickup_node.gd) |
| **Persist** | [inventory_persistence.gd](scripts/inventory_persistence.gd) (ids + amounts, not nested Resources) |
| **Consumables** | [consumable_item_logic.gd](scripts/consumable_item_logic.gd) |
| **DB lookup** | [item_database_loader.gd](scripts/item_database_loader.gd) |

## MANDATORY reads

1. [inventory_item_resource.gd](scripts/inventory_item_resource.gd) — item blueprint  
2. [inventory_data_resource.gd](scripts/inventory_data_resource.gd) — two-pass stack + weight validation  
3. [inventory_ui_controller.gd](scripts/inventory_ui_controller.gd) — reactive UI that **reuses** slot controls  

## NEVER Do in Inventory Systems

- **NEVER use Nodes for items** — `Item extends Resource`.
- **NEVER add without stack/weight pre-checks** — validate capacity first.
- **NEVER let UI mutate inventory arrays silently** — data owns mutations; UI listens.
- **NEVER use `float` for quantities** — `int` stacks.
- **NEVER emit per-item signals in a batch** — one `inventory_updated` after the loop.
- **NEVER hardcode item references** — String/StringName ids + database.
- **NEVER `queue_free` + recreate all slots every refresh** — reuse slot widgets (see UI controller).
- **NEVER allocate new Resources inside `_process`**.

## Decision trees

### Add item
1. Weight/volume OK?  
2. Pass 1: fill partial stacks  
3. Pass 2: empty slots / grid footprint  
4. Return overflow count; single UI signal  

### UI
- Bind once to `inventory_updated`  
- Update existing slot nodes; create only when slot count grows  

### Save
- Serialize `item_id` / `resource_path` + `amount` only — [inventory_persistence.gd](scripts/inventory_persistence.gd)

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Items, slots, and inventories should be `Resource` data (not Nodes) so stacks stay lightweight and shareable as `.tres` databases.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — Use `duplicate(true)` for runtime stack/slot instances so mutating quantity never corrupts the shared item blueprint.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / `@export_group` power Inspector-authored ids, icons, `max_stack`, weight, and loot weights on item Resources.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `inventory_changed` / slot signals so UI reflects data; never let slot widgets mutate arrays silently.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Keep “signals up, calls down”: UI listens; inventory Resources/managers own add/remove/stack logic.
- [GUI containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — `GridContainer` / container sizing is the baseline for slot grids before custom Tetris footprints.
- [Control](https://docs.godotengine.org/en/stable/classes/class_control.html) — Native `_get_drag_data` / `_can_drop_data` / `_drop_data` and `set_drag_preview` implement inventory drag-swap without a custom input stack.
- [Custom GUI controls](https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html) — Pattern for building slot `Control`s that draw icons/counts and participate in drag-and-drop.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist slot ids + amounts (not full recursive Resources) with the rest of player save data.
- [ResourceLoader](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html) — Resolve item blueprints by `resource_path` / id at load time instead of embedding textures in every save blob.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Compact inventory dictionaries (`path`/`id` + `amount`) for `FileAccess` save files without bloating nested Resource graphs.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — Weighted loot rolls and chest contents need seeded RNG patterns, not ad-hoc `randf()` sprinkled in UI code.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Inventory is Resource-first (items, slots, loot tables); learn composition/serialization patterns before inventing Node-based item trees.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Batch-safe `inventory_updated` / slot signals keep reactive UI in sync without per-item spam or ghost connections.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, Array/Dictionary slot maps, and int stack math assume solid GDScript patterns.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Slot grids, equipment panels, and responsive inventory windows build on container layout before drag-drop polish.

#### Complements
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Inventory persistence must round-trip through the project save schema (ids + counts, migration-safe).
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Equipment bonuses, encumbrance, and consumable effects need a consistent stats/modifier layer.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Shops, buy/sell, and rarity-weighted loot tables consume the same item Resources and stack rules.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Consumable scrolls, skill books, and gear that grants abilities bridge inventory grants into AbilityManager registration.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Weapons/armor equipped from inventory feed damage and hit pipelines; keep DamageData separate from item metadata.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Rarity colors, slot styles, and drag previews should live in Theme resources, not hardcoded slot scripts.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After stack sizes, weights, drop rates, and shop prices are data-driven, Monte Carlo sims prove economy/loot bands before shipping curves.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Action-RPG bags, equipment screens, and loot loops assemble this skill with combat, stats, and quests.
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — Weight limits, consumables, and scarce loot are core survival inventory constraints.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Fetch/collect quests query `has_item` and grant rewards through the same inventory add/remove APIs.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
