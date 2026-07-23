---
name: godot-genre-card-game
description: "Expert blueprint for digital card games (CCG/Deckbuilders) including card data structures (Resource-based), deck management (draw/discard/reshuffle), turn logic, hand layout (arcing), drag-and-drop UI, effect resolution (Command pattern), and visual polish (godot-tweening, shaders). Use for CCG, deckbuilders, or tactical card games. Trigger keywords: card_game, deck_manager, card_data, hand_layout, drag_drop_cards, effect_resolution, command_pattern, draw_pile, discard_pile."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Card Game

Expert blueprint for digital card games with data-driven design and juicy UI.

## NEVER Do (Expert Anti-Patterns)

### Logic & Architecture
- NEVER hardcode card logic inside UI scripts; strictly encapsulate gameplay effects in **`Callable` objects** or **Command resources** pushed to a LIFO stack.
- NEVER perform board-state calculations (Power/Toughness) in `_process()`; strictly use **Signal-driven triggers** or a centralized `EffectStack` resolver.
- NEVER forget **LIFO Stack Resolution**; strictly use **`Array.push_back()`** and **`Array.pop_back()`** to resolve reactions from top-to-bottom.

### UX & Animation
- NEVER skip **Z-Index management** during drag-and-drop; strictly raise the card to the front on click to prevent it sliding under other cards.
- NEVER allow instant card "teleportation" between piles; strictly use **`create_tween()`** / **`tween_property`** chains (0.2s+) for pile moves.
- NEVER use `global_position` for cards in hand; strictly position them using a **`Curve2D`** layout with **`sample_baked()`** for smooth arcs.

### Deck & State Management
- NEVER forget to handle **Empty Deck** scenarios; strictly implement auto-reshuffle of the discard pile to prevent soft-locks.
- NEVER use floating point numbers for discrete card stats; strictly use `int` for Costs, Attack, and Health to avoid precision drift.
- NEVER use standard Control nodes for mass tokens/battlefields; strictly use **`_draw()` custom drawing** to bypass SceneTree overhead when rendering 100+ cards or map icons.
- NEVER rely on SceneTree order for hand logic; strictly manage logical order in an **Array** and update visuals via **`queue_redraw()`**.
- NEVER erase array elements during a standard `for` loop; strictly iterate in reverse or use `filter()` to avoid indexing errors.
- NEVER forget to provide parameterless constructors in `_init()`; otherwise, Resources will fail to load in the Inspector.
---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [card_effect_resolution.gd](scripts/card_effect_resolution.gd) — LIFO effect stack (`push_back` / `pop_back`)
> 2. [card_tween_manager.gd](scripts/card_tween_manager.gd) — interruptible pile/hand Tweens (no teleports)
> 3. [card_data_resource.gd](scripts/card_data_resource.gd) — Inspector-safe Resource card definitions

### Original Expert Patterns
- [card_effect_resolution.gd](scripts/card_effect_resolution.gd) - LIFO stack resolver for nested triggers and counter-play.

### Modular Components
- [card_data_resource.gd](scripts/card_data_resource.gd) - Data-driven card definitions allowing Inspector-based design.
- [card_data.gd](scripts/card_data.gd) - Lightweight CardData Resource stub used by validators/tests.
- [deck_shuffle_bag.gd](scripts/deck_shuffle_bag.gd) - Secure randomization patterns for uniform card distribution.
- [turn_state_machine.gd](scripts/turn_state_machine.gd) - Managing rigid phases (Draw, Play, Combat) via state matching.
- [card_drag_drop.gd](scripts/card_drag_drop.gd) - Implementation of native `_get_drag_data()` for Control nodes.
- [board_query_filter.gd](scripts/board_query_filter.gd) - Functional `filter()` patterns for querying board metadata.
- [card_tween_manager.gd](scripts/card_tween_manager.gd) - Managing interruptible card juice and board transitions.
- [reactive_card_ui.gd](scripts/reactive_card_ui.gd) - Resource-signal driven UI for automatic visual state updates.
- [board_state_dictionary.gd](scripts/board_state_dictionary.gd) - Grid-based tracking (Vector2i) decoupled from Node order.
- [match_state_resetter.gd](scripts/match_state_resetter.gd) - Clean-up pattern for in-match temporary Resource modifications.
- [deck_builder_validator.gd](scripts/deck_builder_validator.gd) - Backend logic for deck-building constraints and mana curves.

---

## Core Loop
1. **Draw** → 2. **Evaluate** → 3. **Play** → 4. **Resolve (LIFO stack)** → 5. **Discard/End**

## Decision Trees

### Effect stack
| Need | Action |
|------|--------|
| Nested reactions / counters | **MANDATORY** [card_effect_resolution.gd](scripts/card_effect_resolution.gd) — **LIFO only** (`pop_back`) |
| FIFO sequential animations only | Rare; keep a separate queue — do **not** reuse the reaction stack |

### Hand & board
| Need | Action |
|------|--------|
| Arc hand layout | `Curve2D.sample_baked` + [card_tween_manager.gd](scripts/card_tween_manager.gd) |
| Drag targeting | [card_drag_drop.gd](scripts/card_drag_drop.gd) |
| Dense boards (100+ icons) | `_draw()` / [board_state_dictionary.gd](scripts/board_state_dictionary.gd) — not Control-per-token |

### Data
| Need | Action |
|------|--------|
| Card definitions | **MANDATORY** [card_data_resource.gd](scripts/card_data_resource.gd) (parameterless `_init`) |
| Deck RNG | [deck_shuffle_bag.gd](scripts/deck_shuffle_bag.gd) |
| Turn phases | [turn_state_machine.gd](scripts/turn_state_machine.gd) |

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Data | `resources`, `custom-resources` | Card properties (Cost, Type, Effect) |
| 2. UI | `control-nodes`, `layout-containers` | Hand layout, tooltips |
| 3. Input | `drag-and-drop`, `state-machines` | Targeting, hovering |
| 4. Logic | `command-pattern`, `signals` | LIFO stack, turn phases |
| 5. Polish | `godot-tweening`, `shaders` | Draw juice, foils |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| FIFO `pop_front` on reaction stack | Use LIFO `pop_back` in [card_effect_resolution.gd](scripts/card_effect_resolution.gd) |
| Instant pile snaps | Tween via [card_tween_manager.gd](scripts/card_tween_manager.gd) |
| Float ATK/HP | Use `int` stats on Resources |

## Elite notes (optional polish)
- Holographic foil: UV scroll shader on card Control — not required for stack correctness.
- Card history: signal bus logger for replay/debug; keep off the hot resolve path.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — CardData as `.tres` Resources so designers edit cost/stats without touching UI scripts.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / `@export_group` patterns that drive Inspector-authored card definitions.
- [Control](https://docs.godotengine.org/en/stable/classes/class_control.html) — `_get_drag_data` / `_can_drop_data` / `_drop_data` and `set_drag_preview` for native card drag-and-drop.
- [Custom GUI controls](https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html) — building interactive card faces with `_gui_input`, `mouse_filter`, and `_draw` for dense boards.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — anchoring hand/board zones so layouts survive resolution changes.
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — when HBox/Grid help deck-builder grids vs manual hand arcing.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — interruptible `create_tween()` / `tween_property` juice for draw, play, and discard moves.
- [Beziers, curves and paths](https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html) — math behind arcing hand layouts instead of circular fudge factors.
- [Curve2D](https://docs.godotengine.org/en/stable/classes/class_curve2d.html) — `sample_baked()` for smooth non-circular fan positions and rotations.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — seeded RNG and shuffle-bag fairness for draw piles.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Resource `changed` and effect-stack signals that keep UI reactive without `_process` polling.
- [Your first 2D shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_2d_shader.html) — canvas_item foil/rarity shaders on card faces.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, Autoloads, and import basics before wiring DeckManager and card scenes.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — `.tres` ownership, duplication, and `emit_changed` so match buffs never leak into authored card files.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed Arrays, Callables/Commands, and `match` phases used by effect stacks and turn machines.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Control layout, anchors, and mouse_filter habits required for hand/board hit-testing.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — kill/parallel Tween patterns so rapid plays do not teleport or stack dead tweens.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — bus/signal graphs for draw, play, resolve, and discard without UI owning game rules.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — pointer vs action maps when cards share the viewport with keyboard shortcuts and accessibility drag.
- [godot-turn-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md) — Draw/Main/Combat/End phase ownership that this skill's turn state machine plugs into.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — canvas_item rarity foils and highlight materials beyond the skill's starter hologram snippet.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate mulligans, mana curves, and win-rate vs cost/power so card stats stay fair under RNG.
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — run-based deckbuilders that consume CardData, shops, and per-act draft pools.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — collection/deck-builder UIs that persist owned cards separately from the in-match piles.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — keyword/status effects (Poison, Taunt, Shield) resolved as reusable ability resources on the stack.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
