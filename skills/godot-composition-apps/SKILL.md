---
name: godot-composition-apps
description: "Expert architectural standards for scalable Godot Apps, Tools, EditorPlugins, and Control-heavy UIs using Composition (Has-A Orchestrator + components). Use when building dashboards, tool windows, forms, settings panels, or EditorPlugin UIs. Do NOT use for gameplay entities (Player/Enemy/Weapon/Hitbox) — route those to godot-composition. Trigger keywords: Control, EditorPlugin, tool UI, Orchestrator, VLS, rock test, AuthComponent, ThemeManager, Saveable component, dependency injection."
---

# Godot Composition & Architecture (Apps & UI)

## Decision Gate — App vs Gameplay Entity

| Root node / task | Route |
|------------------|-------|
| Control, EditorPlugin, tool window, settings dock, form UI | **Stay here** — Orchestrator + components |
| Player, Enemy, Weapon, Hitbox, gameplay CharacterBody | **[godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md)** — not this skill |

**App-only gate:** If the node is a gameplay actor (Player/Enemy/Weapon/Hitbox), use godot-composition. This skill owns **Control / EditorPlugin / tool** composition.

## The Core Philosophy

### The Litmus Test (Rock Test)
Before writing a script, ask: **"If I attached this script to a literal rock, would it still function?"**
- **Pass:** An `AuthComponent` on a rock allows the rock to log in. (Context Agnostic)
- **Fail:** A `LoginForm` script on a rock tries to grab text fields the rock doesn't have. (Coupled)

**MANDATORY:** Validate new components with [comp_rock_test_boilerplate.gd](scripts/comp_rock_test_boilerplate.gd).

### The Backpack Model (Has-A > Is-A)
Treat the Root Node as an empty **Backpack**.
- **Wrong:** `SubmitButton` extends `AnimatedButton` extends `BaseButton`.
- **Right:** Root **HAS-A** `AnimationComponent` and **HAS-A** `NetworkRequestComponent`.

## The Hierarchy of Power (Communication Rules)

| Direction | Source → Target | Method | Reason |
|-----------|-----------------|--------|--------|
| **Downward** | Orchestrator → Component | **Function Call** | Manager owns the workers. |
| **Upward** | Component → Orchestrator | **Signals** | Workers are blind. |
| **Sideways** | Component A ↔ Component B | **FORBIDDEN** | Siblings never talk directly. |

**Sideways Fix:** Component A signals the Orchestrator; Orchestrator calls Component B.

## Available Scripts

> **MANDATORY**: Read the matching script before implementing the pattern. Do not reinvent Orchestrator wiring inline.

### [comp_rock_test_boilerplate.gd](scripts/comp_rock_test_boilerplate.gd)
**MANDATORY first read** — Attach-candidate-to-literal-rock harness that fails hard-coupled components early.

### [comp_orchestrator_base.gd](scripts/comp_orchestrator_base.gd)
**MANDATORY** when creating any App/UI root — Signal-up / call-down wiring skeleton (0% business math).

### [comp_logic_visual_syncer.gd](scripts/comp_logic_visual_syncer.gd)
**MANDATORY** for VLS — Logic emits `state_changed`; visuals/animations react without logic knowing `AnimationPlayer`/`Theme`.

### [comp_base_component.gd](scripts/comp_base_component.gd)
Shared component lifecycle + dependency validation for app workers.

### [comp_dependency_injector.gd](scripts/comp_dependency_injector.gd)
Typed export / registry injection so Orchestrators avoid brittle `$` paths.

### [comp_data_driven_config.gd](scripts/comp_data_driven_config.gd)
Resource-backed config for tool settings and form defaults.

### [comp_persistence_component.gd](scripts/comp_persistence_component.gd)
**MANDATORY for saveable UI/tool state** — Registers `Saveable` group + `get_save_data()` without putting I/O in visuals.

### [comp_ability_sequencer.gd](scripts/comp_ability_sequencer.gd)
Ordered multi-step tool workflows (wizard pages, export pipelines) as child steps.

### [comp_health_component.gd](scripts/comp_health_component.gd) / [comp_hitbox_component.gd](scripts/comp_hitbox_component.gd)
Only when an app/tool simulates entities; prefer godot-composition for real games.

## The Orchestrator Pattern

Root script (`LoginScreen.gd`, `UserProfile.gd`, EditorPlugin dock root) is an **Orchestrator**:
- Math/Logic: 0% · State wiring: 100%
- Job: listen to component signals → call other component methods

**MANDATORY:** Extend patterns from [comp_orchestrator_base.gd](scripts/comp_orchestrator_base.gd).

| Concept | App/UI Example |
|---------|----------------|
| Orchestrator | `UserProfile.gd` / Editor dock root |
| Logic component | `AuthValidator` |
| VLS | `AuthVisualSyncer` via [comp_logic_visual_syncer.gd](scripts/comp_logic_visual_syncer.gd) |
| Theme ownership | Separate theme component — never mutated inside form logic |
| Focus ownership | Orchestrator grants/releases Control focus; components never steal siblings' focus |

## Implementation Standards

1. **Type Safety** — `class_name` on components; no untyped core architecture.
2. **Dependency Injection** — `@export var auth: AuthComponent` (Inspector / `%UniqueNames`). **NEVER** `get_node("Path/To/Child")` for components.
3. **Stateless workers** — Orchestrator passes data into functions; components do not scrape sibling Controls.

## NEVER Do (Expert Architectural Rules)

### Hierarchy & Dependencies
- **NEVER use get_parent() to fetch data** — Inject via `@export` or function args.
- **NEVER talk sideways** — Signal up; Orchestrator calls down.
- **NEVER use brittle Node Paths** — Prefer `@export` / `%`.

### Logic & State
- **NEVER put business logic in the Orchestrator** — Only `_on_signal` delegators.
- **NEVER store global state in individual components** — Shared Context Resource or Autoload.
- **NEVER assume a component's parent is a specific type** — Rock Test failure.

### Polish & Orchestration
- **NEVER skip signal cleanup** — Disconnect on exit / use CONNECT_ONE_SHOT where appropriate.
- **NEVER let Logic know about Visuals** — Emit; VLS / Orchestrator plays animations and applies Theme.

## Godot 4.7: App UI

- **Control offset transform** for non-destructive visual tweaks in tool UIs.
- Editor-style **searchable dropdowns** pattern applicable to in-app pickers.

## Fragile App Workflow: Saveable + Theme Ownership

Do **not** put save I/O or Theme mutation inside form Controls. Route through components:

1. **MANDATORY** [comp_persistence_component.gd](scripts/comp_persistence_component.gd) on the Orchestrator (or a dedicated Saveable child) — `add_to_group("Saveable")` + `get_save_data()`.
2. Theme / StyleBox changes belong in a theme component ([theme_manager.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/resources/theme_manager.gd)) called **down** by the Orchestrator after logic signals success/failure.
3. Focus: Orchestrator owns `grab_focus()` after validation failures so logic stays Control-agnostic.

```gdscript
# settings_dock_orchestrator.gd (pattern — wire via @export, not $)
extends Control
@export var persistence: CompPersistenceComponent
@export var theme_mgr: Node  # theme_manager.gd API
@export var form_logic: Node

func _ready() -> void:
    form_logic.settings_valid.connect(_on_settings_valid)
    form_logic.settings_invalid.connect(_on_settings_invalid)

func _on_settings_valid(payload: Dictionary) -> void:
    theme_mgr.apply_user_theme(payload.get("theme_id"))
    # Save systems collect via Saveable group — persistence component stays dumb

func _on_settings_invalid(field: StringName) -> void:
    # Orchestrator owns focus; logic never touches sibling LineEdits
    var target := get_node_or_null("%" + String(field))
    if target is Control:
        target.grab_focus()
```

## Expert Composition Patterns (Apps)

### 1. App-Level Service Locator
Prefer `Engine.register_singleton()` for lightweight non-Node services (Auth, Config) instead of dozens of Autoload Nodes [6].

### 2. Visual-Logic-Syncers (VLS)
**MANDATORY** [comp_logic_visual_syncer.gd](scripts/comp_logic_visual_syncer.gd) — logic never calls `AnimationPlayer.play()`.

### 3. O(1) Component Registry
Orchestrator Dictionary registry for dashboard modules — still no sideways calls; registry is Orchestrator-private lookup.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Canonical signal-up / call-down ownership so Orchestrators wire components without sibling coupling.
- [When and how to avoid using nodes for everything](https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html) — Prefer Resources/RefCounted for pure data and logic services so components stay lean and rock-testable.
- [Godot interfaces](https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html) — Duck-typed method contracts (`has_method`) that let composition work without deep inheritance trees.
- [What are Godot classes?](https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html) — Why Godot favors scene composition (Has-A) over classical Is-A hierarchies for reusable behaviors.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Upward component→Orchestrator events that keep workers blind to parents and siblings.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — Typed `@export` dependency injection that replaces brittle `get_node` paths in the Inspector.
- [Scene Unique Nodes](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html) — `%UniqueName` for Orchestrator-local Control/Button wiring without string path fragility.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Data-driven `.tres` configs so values stay outside logic components.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Mass registration (e.g. Saveable/Components) for Orchestrator registries without hard sibling refs.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — When a scene-local Orchestrator beats a global Autoload for app/UI composition.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Safe registration of cross-scene services when a true app-level locator is justified.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persistence patterns that map cleanly onto modular saveable components.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, Autoload registration, and scene ownership that Orchestrators and components plug into.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed exports, signals, and `class_name` fluency required before dependency injection and rock-testable components.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Core Has-A component model (game-focused sibling); this skill specializes the same rules for Apps/Tools/UI.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Connect flags, ghost cleanup, and EventBus patterns Orchestrators use for upward wiring.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Boot order and ownership when composition needs a thin global service instead of scene-local state.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Custom Resources and hot-swap `.tres` configs that feed data-driven components.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Control trees that should signal intent upward while Orchestrators call down into layout.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Theme/visual syncers stay separate from auth/form logic under the VLS pattern.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Scene swaps must re-inject exports and reconnect Orchestrator wiring without sideways sibling links.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — Rock-test and signal spies that prove components stay context-agnostic.

#### Downstream / consumers
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Consumes Saveable-group persistence components for modular app state.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Ability nodes as child components sequenced by an Orchestrator without inheritance trees.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — State nodes compose beside logic/visual syncers; FSM owns transitions, not sibling chatter.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting architecture concern.
