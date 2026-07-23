---
name: godot-dialogue-system
description: "Expert patterns for branching dialogue systems including dialogue graphs (Resource-based), character portraits, player choices, conditional dialogue (flags/quests), typewriter effects, localization support, and voice acting integration. Use for narrative games, RPGs, or visual novels. Trigger keywords: DialogueLine, DialogueChoice, DialogueGraph, dialogue_manager, typewriter_effect, branching_dialogue, dialogue_flags, localization, voice_acting."
---

# Dialogue System

Data-driven dialogue routing — not beginner typewriter tutorials.

## NEVER Do in Dialogue Systems

- **NEVER hardcode dialogue text in GDScript** — Store lines in Resources / JSON / CSV so localization works.
- **NEVER show choices the player has not unlocked** — Hide (or intentionally gray) gated options.
- **NEVER use unvalidated loose strings for node transitions** — Typos in `next_node_id` soft-lock mid-convo; assert / registry IDs.
- **NEVER force a typewriter without skip** — Click/confirm must finish the line immediately.
- **NEVER drive reveal with per-character `Timer` / `OS.delay_msec()`** — Use `visible_ratio` / `visible_characters` + Tween (see [typebox_effect.gd](../scripts/dialogue_system_typebox_effect.gd)).
- **NEVER store dialogue cursor state only in the UI node** — Scene changes drop the player; keep progress in the manager Autoload / session object.
- **NEVER `get_node()` from NPCs into Dialogue UI** — Start via manager signals (`start_dialogue(res)`).
- **NEVER invent regex for BBCode** — Prefer RichTextLabel BBCode / custom effects.
- **NEVER save/load inside a dialogue node Resource** — Nodes are data; persistence belongs to SaveSystem.
- **NEVER hardcode portrait paths in code** — Assign textures on node Resources or a portrait database.

---

## Godot 4.7: Dialogue UI

- RichTextLabel `add_image`/`update_image` use `width_unit`/`height_unit` (`ImageUnit`) — update portrait and inline image helpers.

## Decision Tree: Authoring Engine

| Authoring need | Engine | MANDATORY scripts | Do NOT Load |
|----------------|--------|-------------------|-------------|
| Designer-friendly `.tres` graphs in-repo | **Resource Autoload graph** | [dialogue_resource.gd](../scripts/dialogue_system_dialogue_resource.gd) → [dialogue_manager_singleton.gd](../scripts/dialogue_system_dialogue_manager_singleton.gd) → [dialogue_ui_controller.gd](../scripts/dialogue_system_dialogue_ui_controller.gd) → [typebox_effect.gd](../scripts/dialogue_system_typebox_effect.gd) | [dialogue_engine.gd](../scripts/dialogue_system_dialogue_engine.gd) JSON path |
| External writers / spreadsheet → JSON | **JSON graph engine** | [dialogue_engine.gd](../scripts/dialogue_system_dialogue_engine.gd) (+ optional [dialogue_manager.gd](../scripts/dialogue_system_dialogue_manager.gd)) → UI + typebox | Resource Autoload stack |
| Visual node editor in-project | **GraphEdit authoring** | Keep runtime on Resource or JSON export; GraphEdit is editor-only tooling | Shipping GraphEdit as the runtime walker |
| Conditions / quest gates | Either | [branching_condition_validator.gd](../scripts/dialogue_system_branching_condition_validator.gd) | Embedding flag checks in UI buttons |
| Portraits / expressions | Either | [dialogue_portrait_manager.gd](../scripts/dialogue_system_dialogue_portrait_manager.gd) | — |
| Localization keys | Either | [localized_dialogue_resource.gd](../scripts/dialogue_system_localized_dialogue_resource.gd) | Hardcoded language `if` trees |
| Quest / gameplay hooks from lines | Either | [dialogue_event_bridge.gd](../scripts/dialogue_system_dialogue_event_bridge.gd) | Side effects inside UI controller |

**Default golden path:** Resource Autoload → UI controller → typebox_effect. Pick **one** runtime engine; do not run Resource manager and JSON engine in parallel.

## Available Scripts (single catalog)

### Runtime (golden path)
- [dialogue_resource.gd](../scripts/dialogue_system_dialogue_resource.gd) — conversation tree Resource
- [dialogue_node_data.gd](../scripts/dialogue_system_dialogue_node_data.gd) — single line / speaker / portrait metadata
- [dialogue_option_data.gd](../scripts/dialogue_system_dialogue_option_data.gd) — choice + conditions
- [dialogue_manager_singleton.gd](../scripts/dialogue_system_dialogue_manager_singleton.gd) — **MANDATORY** Autoload walker + signals
- [dialogue_ui_controller.gd](../scripts/dialogue_system_dialogue_ui_controller.gd) — **MANDATORY** labels / choice buttons
- [typebox_effect.gd](../scripts/dialogue_system_typebox_effect.gd) — **MANDATORY** skip-safe Tween `visible_ratio` reveal

### Supporting
- [dialogue_event_bridge.gd](../scripts/dialogue_system_dialogue_event_bridge.gd) — fire gameplay events from nodes
- [branching_condition_validator.gd](../scripts/dialogue_system_branching_condition_validator.gd) — flag/stat gates
- [localized_dialogue_resource.gd](../scripts/dialogue_system_localized_dialogue_resource.gd) — translation keys
- [dialogue_portrait_manager.gd](../scripts/dialogue_system_dialogue_portrait_manager.gd) — expression swaps

### Alternate engines (load only if decision tree says so)
- [dialogue_engine.gd](../scripts/dialogue_system_dialogue_engine.gd) — JSON graphs + BBCode `[trigger:]` tags
- [dialogue_manager.gd](../scripts/dialogue_system_dialogue_manager.gd) — alternate data-driven walker

## Typewriter Contract (skip-safe)

Use [typebox_effect.gd](../scripts/dialogue_system_typebox_effect.gd): set full `text`, tween `visible_ratio` (or RichTextLabel `visible_characters`) from 0→1. On skip input: kill tween and snap visibility to complete. **Do not** spawn a Timer per character.

## Elite Deltas

- **GraphEdit auditor:** `@tool` GraphEdit for dependency visualization; export to Resource/JSON for runtime.
- **Audio-driven lines:** drive reveal from voice length / lipsync clocks; still allow skip.
- **Analytics:** log node IDs + choice IDs for funnel tuning (no PII).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Why dialogue graphs belong in `Resource` / `.tres` data instead of hardcoded strings in scripts.
- [BBCode in RichTextLabel](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html) — Native markup for speaker emphasis, custom tags, and effects without rolling your own parser.
- [RichTextLabel](https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html) — `visible_characters` / image helpers and BBCode APIs the dialogue UI should drive for typewriter and portraits.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — `tr()` / TranslationServer workflow so line text stays key-based across locales.
- [Localization using spreadsheets](https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_spreadsheets.html) — CSV translation tables that map cleanly onto dialogue `text_key` fields.
- [Importing translations](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html) — How Godot imports CSV/PO so localized dialogue resources resolve at runtime.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit line/choice/end events upward so UI, quests, and audio never hard-reference the manager internals.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Register a `DialogueManager` that survives scene changes and owns traversal state.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Drive `visible_ratio` / character reveal timing without blocking the main thread.
- [Text-to-speech](https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html) — `DisplayServer` TTS callbacks for placeholder VO and lipsync-adjacent timing.
- [GraphEdit](https://docs.godotengine.org/en/stable/classes/class_graphedit.html) — Editor surface for authoring branching dialogue graphs when `.tres` lists become unwieldy.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Parse external dialogue graph files when designers prefer JSON over Resources.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoload registration, input for advance/skip, and project layout dialogue UI scenes plug into.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, signals, `await`, and Callables required before branching engines and UI bridges.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Canonical patterns for `DialogueLine` / graph Resources, exports, and avoiding duplicated mutable state.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton ownership and boot order for a global `DialogueManager` that must outlive scene swaps.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Signal-up / call-down contracts for `line_displayed`, choice selection, and narrative event bridges.
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — RichTextLabel BBCode, custom effects, and image embedding beyond the basics used in typewriter UIs.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Layout choice buttons and dialogue panels without fighting Control sizing and focus.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Skip-safe Tweens for character reveal, portrait entry, and panel transitions.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Voice-line players, bus ducking during dialogue, and subtitle sync with spoken audio.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Quest flags and objectives that gate conditional choices and fire from dialogue event bridges.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist dialogue flags / seen-node state outside UI nodes so progress survives reloads.

#### Downstream / consumers
- [godot-genre-visual-novel](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md) — Full VN presentation loops consume this skill’s graph traversal, portraits, and choice UI patterns.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Dialogue effects often grant/require items; keep grant logic in inventory, not inside line Resources.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate skill-check / branching choice trees when narrative gates or reward paths need balance passes.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns narrative, UI, or quest concerns.
