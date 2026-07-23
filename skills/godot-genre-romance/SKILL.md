---
name: godot-genre-romance
description: "Expert blueprint for romance games and dating sims (Tokimeki Memorial, Monster Prom, Persona social links) focusing on affection systems, multi-stat relationships, dated events, and route branching. Use when building relationship-centric games, social simulations, or otome games. Keywords romance, dating sim, affection system, relationship stats, date events, character routes, love interest."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Romance & Dating Sim

Romance games are built on the "Affection Economy"—the management of player time and resources to influence NPC attraction, trust, and intimacy.

## Core Loop
1.  **Meet**: Encounter potential love interests and establish baseline rapport.
2.  **Date**: Engage in structured events to learn preferences and test compatibility.
3.  **Deepen**: Invest resources (time, gifts, choices) to increase affection/stats.
4.  **Branch**: Story diverges into character-specific "Routes" based on major milestones.
5.  **Resolve**: Reach a specialized ending (Good/Normal/Bad) based on relationship quality.

## NEVER Do (Expert Anti-Patterns)

### Romance & NPC Logic
- NEVER create "Vending Machine" romance; strictly incorporate variables like **NPC Mood**, **Timing**, and **Multi-Stat Thresholds** to ensure characters feel autonomous.
- NEVER use binary Affection (Love/Hate); strictly use a **Multi-Axial Model** (Attraction, Trust, Comfort) for believable psychological depth.
- NEVER focus on 100% opaque stats; strictly provide **Visible Indicators** (heart UI, blushing text, pulsing hearts) to help players make informed choices.
- NEVER use the "Same Date Order" trap; strictly implement a **Repetition Penalty** (~30%) for visiting the same location twice in a row.
- NEVER forget "Missable" Milestones; strictly ensure meaningful consequences (e.g., missing events due to poor scheduling) to add weight to the experience.
- NEVER ignore NPC Autonomy; strictly allow NPCs to have their own **Schedules** and the ability to **Reject** the player based on low trust or conflicting events.
- NEVER use polling (`_process`) for NPC schedule checks; strictly use a **Signal-Driven TimeManager** (Autoload) to broadcast hour/day changes for performant state updates.
- NEVER hardcode character references for jealousy logic; strictly use **Groups (`add_to_group`)** to broadcast romantic events across the scene for decoupled, autonomous NPC reactions.

### Technical & UI
- NEVER use `_process` for typewriter text; strictly use **Tweens on `visible_ratio`** for frame-independent, smooth reveals.
- NEVER parse massive narrative files on the main thread; strictly use **`ResourceLoader.load_threaded_request()`** to prevent transition stutters.
- NEVER use exact float math for affection checks; strictly use **`is_equal_approx()`** to avoid jitter-based logic failures.
- NEVER structure complex dialogue purely in code; strictly design dialogue trees as **Custom `Resource` classes** to decouple narrative data from logic.
- NEVER rely on the global OS clock for timed choices; strictly use **`SceneTreeTimer`** which respects `Engine.time_scale` and pause states.
- NEVER leave invisible controls with `MOUSE_FILTER_STOP`; strictly set to `IGNORE` or `PASS` on non-opaque layers to avoid blocking dialogue progression.
- NEVER hardcode dialogue strings; strictly map text to **Localization Keys** and retrieve via `tr()` for internationalization.
- NEVER use absolute pixel positioning for interfaces; strictly rely on **Anchoring & Containers** for responsive scaling across devices.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [affection_manager.gd](scripts/affection_manager.gd) — multi-axial Attraction/Trust/Comfort
> 2. [date_event_system.gd](scripts/date_event_system.gd) — dates + repetition penalty
> 3. [route_manager.gd](scripts/route_manager.gd) — route lock / CG flags

### Original Expert Patterns
- [affection_manager.gd](scripts/affection_manager.gd) - Multi-axis Attraction/Trust/Comfort tracking and gift logic.
- [date_event_system.gd](scripts/date_event_system.gd) - Variety-aware dating with repetition penalties.
- [route_manager.gd](scripts/route_manager.gd) - Flag-based route branching and CG gallery persistence.

### Modular Components
- [romance_mood_manager.gd](scripts/romance_mood_manager.gd) - Mood modifiers that gate dialogue options.
- [dialogue_expression_parser.gd](scripts/dialogue_expression_parser.gd) - Expression / emotion tags for portrait swaps.
- [global_affection_tracker.gd](scripts/global_affection_tracker.gd) - Cross-scene Autoload snapshot of all axes.
- [romance_patterns.gd](scripts/romance_patterns.gd) - Typewriter tweens and heart-burst juice helpers.

---

## Core Loop
1. **Meet** → 2. **Schedule / talk** → 3. **Date / gift** → 4. **Milestone** → 5. **Route lock or continue parallel**

## Decision Trees

### Affection & dialogue
| Need | Action |
|------|--------|
| Multi-axis stats | **MANDATORY** [affection_manager.gd](scripts/affection_manager.gd) |
| Global HUD / jealousy groups | [global_affection_tracker.gd](scripts/global_affection_tracker.gd) + `call_group` |
| Mood-gated lines | [romance_mood_manager.gd](scripts/romance_mood_manager.gd) |
| Portrait tags | [dialogue_expression_parser.gd](scripts/dialogue_expression_parser.gd) |

### Routes vs parallel dating
| Situation | Choice |
|-----------|--------|
| Early game exploration | Keep routes **unlocked**; raise Attraction freely; Trust gates deeper personal scenes |
| Mid-game exclusive confession | **Lock route** via [route_manager.gd](scripts/route_manager.gd) when Trust ≥ threshold **and** player accepts — freeze rival romance flags |
| Parallel dating fantasy | Allow multiple Attraction tracks, but jealousy groups cut Trust on discovered overlaps |
| Confession readiness | Attraction opens the prompt; **Trust** decides success vs soft rejection; Comfort reduces timed-choice panic fail |

Do **not** re-inline affection/date/route class stubs — load the scripts above.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Stats | `dictionaries`, `resources` | Multi-axis affection |
| 2. Timeline | `autoload-architecture`, `signals` | Schedules / days |
| 3. Narrative | `godot-dialogue-system`, `visual-novel` | Branching choices |
| 4. Persist | `godot-save-load-systems` | Routes, CGs, flags |
| 5. Juice | `ui-theming`, `godot-tweening` | Hearts / blush |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Vending-machine romance | Multi-axis + repetition penalty on dates |
| Opaque stats | Surface Attraction/Trust/Comfort deltas in UI |
| Garbled script index | Use filenames above (no broken path fragments) |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Author `CharacterProfile`, date locations, and seasonal dialogue as data Resources instead of hardcoded trees.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Host TimeManager / global affection trackers so schedules and stats survive scene changes.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Drive milestones, `stats_changed`, and hour/day clocks without `_process` polling.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Broadcast date starts to `romantic_interests` for jealousy without hardcoding NPC refs.
- [BBCode in RichTextLabel](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html) — Blush, shake, and custom emotive effects for dating-sim dialogue juice.
- [Evaluating expressions](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html) — Gate choices with runtime `Expression` checks against affection / route flags.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist routes, CG gallery unlocks, and multi-axis relationship dictionaries.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Thread-load large narrative Resources so route transitions do not hitch.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — Map dialogue and choice text through `tr()` / localization keys.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — Keep heart UI and choice panels responsive without absolute pixel layouts.
- [Pausing games](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html) — Timed choices and romance menus must respect `SceneTree` pause / `time_scale`.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Typewriter `visible_ratio` and heart-burst pulses without `_process` timers.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Character profiles, gift tables, and `DateLocation` data belong in typed Resources before wiring affection math.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Global affection / TimeManager singletons need correct boot order and ownership so route state is not scene-local.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Milestone, mood, and schedule buses must stay Signal-Up so UI and NPCs never poll relationship dictionaries.
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Branching conversation trees and choice consequences are the narrative substrate under affection gates.

#### Complements
- [godot-genre-visual-novel](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md) — Pair route locks and CG gallery with VN presentation (portraits, backgrounds, advance UX).
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — Custom BBCode / RichTextEffect patterns for blushing, nervous shake, and meta-linked choices.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Typewriter reveals, portrait crossfades, and heart-burst juice without frame-tied timers.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Serialize multi-axis stats, route flags, and gallery unlocks with a real save pipeline.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Gift items and diminishing-return histories plug into affection via inventory ownership.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Heart meters, blush chrome, and choice panels stay consistent across romance UI scenes.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Tune gift values, date thresholds, and repetition penalties so routes stay reachable without grind or soft-locks.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Expose confession deadlines and missable milestones as timed quest gates on the calendar.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Mood overlays and route beats usually need BGM / stinger buses coordinated with affection events.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering romance peers (dialogue, VN, save, UI).
