---
name: godot-quest-system
description: "Expert blueprint for quest  tracking systems (objectives, progress, rewards, branching chains) using Resource-based quests, signal-driven updates, and AutoLoad managers. Use when implementing RPG quests or mission systems. Keywords quest, objectives, Quest Resource, QuestObjective, signal-driven, branching, rewards, AutoLoad."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Quest System

Resource-based quests + Autoload manager. **Single source of truth:** [quest_resource.gd](scripts/quest_resource.gd) + [quest_manager_singleton.gd](scripts/quest_manager_singleton.gd) — no inline Quest/Objective/Manager/UI dumps.

## MANDATORY loads

1. [quest_resource.gd](scripts/quest_resource.gd) — `StringName` ids, status, objectives/rewards  
2. [quest_manager_singleton.gd](scripts/quest_manager_singleton.gd) — accept / progress / complete / chain  

Supporting: [kill_objective_trigger.gd](scripts/kill_objective_trigger.gd), [quest_ui_tracker.gd](scripts/quest_ui_tracker.gd), [branching_quest_data.gd](scripts/branching_quest_data.gd), [quest_giver_dialogue_hook.gd](scripts/quest_giver_dialogue_hook.gd), [quest_persistence_loader.gd](scripts/quest_persistence_loader.gd), [timed_quest_challenge.gd](scripts/timed_quest_challenge.gd), [hidden_objective_logic.gd](scripts/hidden_objective_logic.gd), [localized_quest_description.gd](scripts/localized_quest_description.gd), [quest_graph_manager.gd](scripts/quest_graph_manager.gd), [quest_manager.gd](scripts/quest_manager.gd) (alt helper — prefer singleton).

## Golden path

```
accept → event trigger → progress → complete → persist
```

| Checkpoint | Action |
|---|---|
| **Accept** | `QuestManager.accept_quest(quest)` — duplicate Resource if runtime mutation; connect `quest_completed` once |
| **Event trigger** | Kill/collect/talk via trigger nodes / bus — **not** hardcoded in enemy scripts ([kill_objective_trigger.gd](scripts/kill_objective_trigger.gd)) |
| **Progress** | `update_objective(quest_id: StringName, …)` — interned ids only |
| **Complete** | Manager erases active, emits `quest_completed`, grants via inventory/economy signals |
| **Disconnect** | Disconnect completion Callables when quest leaves active set — prevent double rewards |
| **Persist** | Save active/completed id maps + counts ([quest_persistence_loader.gd](scripts/quest_persistence_loader.gd)) — not live Resource graphs |

## NEVER Do in Quest Systems

- **NEVER store active quests only on the Player node** — Autoload / persistent data.
- **NEVER use unverified plain string ids** — `StringName` / registry (`&"kill_slimes"`).
- **NEVER forget to disconnect completion signals** — double rewards.
- **NEVER poll objectives in `_process`** — signal-driven.
- **NEVER skip save/load for quest state**.
- **NEVER hardcode quest logic inside enemy/item scripts** — triggers/bus.
- **NEVER award loot inside the Quest Resource** — emit; inventory/economy grant.
- **NEVER allow duplicate active instances of the same quest id**.

## Field alignment (`StringName`)

Across body + scripts use:

- `quest.id: StringName`
- `objective_id: StringName`
- Manager dictionaries keyed by `StringName`
- Dialogue/quest-giver hooks compare `StringName`, not free strings

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Why quest definitions, objectives, and reward tables belong in reusable `Resource` assets instead of scene-local scripts.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — `@export`, nested Resources, and duplication rules for Inspector-authored quest data and branching chains.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — How to register a typed QuestManager that survives scene changes without living on the Player node.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — When global quest state is justified vs keeping progress on a scene-owned data Resource.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit/connect model for `quest_accepted` / `objective_updated` without polling in `_process()`.
- [Instancing with signals](https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html) — Wire kill/collect/talk triggers from spawned actors into the manager without hardcoded node paths.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist quest IDs and progress counts as dictionaries — never serialize live Quest Resource instances.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — Store `tr()` keys on quest Resources so titles/descriptions localize without forked `.tres` files.
- [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) — Time-limited challenge fail paths via `Timer` / `SceneTree.create_timer` timeout signals.
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — Reactive `VBoxContainer` quest trackers that rebuild Labels from manager signals only.
- [StringName](https://docs.godotengine.org/en/stable/classes/class_stringname.html) — Prefer interned IDs for objectives/quests to avoid silent typo failures from plain strings.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Signal-up / call-down ownership so NPCs and enemies never own quest completion math.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Custom Resources, duplication, and Inspector authoring patterns that quest definitions and objective graphs depend on.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Typed emit/connect, disconnect hygiene, and EventBus routing for kill/collect triggers without ghost listeners.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Boot order and ownership rules for a singleton QuestManager that outlives scene swaps.

#### Complements
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Quest-giver offer/reminder/thanks branches should query quest status and emit accept/complete through dialogue choices.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Collect objectives and reward grants should delegate item mutations to inventory, not embed stacks in quest scripts.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Slot/versioned save pipelines that serialize active/completed quest dictionaries beside player state.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Layout and rebuild patterns for objective trackers and journal panels driven only by manager signals.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Currency/XP reward sinks after quest completion; keep grant logic out of the Quest Resource itself.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate reward curves, timed-fail rates, and objective difficulty before locking quest economy numbers.

#### Downstream / consumers
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Level gates, XP rewards, and stat prerequisites that unlock or complete quest acceptance checks.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Death/defeat events feed kill objectives through a bus instead of enemy scripts calling QuestManager directly.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Genre composition that consumes quest tracking, dialogue hooks, and reward distribution as one RPG loop.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Objective waypoints and compass helpers update `NavigationAgent` targets when objectives change.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns quests vs dialogue, inventory, or save.
