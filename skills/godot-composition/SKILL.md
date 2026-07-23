---
name: godot-composition
description: "Expert architectural standards for building scalable Godot GAMES (RPGs, Platformers, Shooters) using the Composition pattern (Entity-Component). Use when designing player controllers, NPCs, enemies, weapons, or complex gameplay systems. Enforces \"Has-A\" relationships for game entities. Trigger keywords: Entity-Component, ECS, Gameplay, Actors, NPCs, Enemies, Weapons, Hitboxes, Game Loop, Level Design."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Godot Composition Architecture

## Core Philosophy
This skill enforces **Composition over Inheritance** ("Has-a" vs "Is-a").
In Godot, Nodes **are** components. A complex entity (Player) is simply an Orchestrator managing specialized Worker Nodes (Components).

### The Golden Rules
1.  **Single Responsibility**: One script = One job.
2.  **Encapsulation**: Components are "selfish." They handle their internal logic but don't know *who* owns them.
3.  **The Orchestrator**: The root script (e.g., `player.gd`) does **no logic**. It only manages state and passes data between components.
4.  **Decoupling**: Components communicate via **Signals** (up) and **Methods** (down).

## Decision Tree — Composition vs Autoload vs Inheritance

| Situation | Choose |
|-----------|--------|
| Gameplay entity behaviors (HP, hitbox, move, interact) | **Composition** — child components + orchestrator ([composition_root_init.gd](scripts/composition_root_init.gd)) |
| Cross-scene services (audio bus, save, net, economy ledger) | **Autoload** — not a component on the player |
| True is-a engine specialization (custom Control/Node with shared lifecycle) | **Inheritance exception** — rare; never for "adds a gun" / "adds HP" |

---

## Available Scripts

### [health_component.gd](scripts/health_component.gd)
Specialized Node for managing lifespan, damage logic, and death signals across any entity.

### [hit_box_component.gd](scripts/hit_box_component.gd)
Area-based component for intercepting damage and delegating it to a HealthComponent.

### [hurt_box_component.gd](scripts/hurt_box_component.gd)
Area-based component for dealing damage specifically to HitBoxComponents.

### [velocity_component.gd](scripts/velocity_component.gd)
Encapsulated movement and acceleration logic for reuse across Players and Enemies.

### [interaction_component.gd](scripts/interaction_component.gd)
Decoupled interaction handler using injecting `Callable` logic for context-aware actions.

### [follower_component.gd](scripts/follower_component.gd)
Decoupled tracking logic using `NodePath` injection for smooth entity following.

### [state_component_vsm.gd](scripts/state_component_vsm.gd)
Component-based state machine pattern using child nodes as individual states.

### [status_effect_component.gd](scripts/status_effect_component.gd)
Managing temporary modifiers (buffs/debuffs) by stacking effect scenes as children.

### [visual_sync_component.gd](scripts/visual_sync_component.gd)
Separating logical state (velocity/direction) from visual representation (sprite flipping).

### [composition_root_init.gd](scripts/composition_root_init.gd)
**MANDATORY first read** — Orchestrator wiring via typed `@export` (Inspector / `%UniqueNames` in the scene). Matches NEVER: no `$` / `get_node` for components.

## NEVER Do in Composition

- **NEVER use deep inheritance chains** (e.g., `Player > Entity > LivingThing > Node`) — Creates brittle "God Classes" that are hard to refactor [21].
- **NEVER use `get_node()` or `$` for components** — This breaks if the scene tree is rearranged. Always use `@export` or `%UniqueNames` [22].
- **NEVER let a component reference its parent script directly** — This makes the component impossible to reuse. Use signals or dependency injection [23].
- **NEVER mix Input, Physics, and Game Logic in one script** — This violates Single Responsibility. Split them into specialized components [24, 13].
- **NEVER create components that require a specific SceneTree structure** — A component should be "selfish" and only care about its own properties and direct children.
- **NEVER use inheritance to "add a feature"** — If you want an enemy to shoot, add a `ShootingComponent`, don't make it inherit from `ShooterEnemy`.
- **NEVER hardcode component dependencies** — If `CombatComponent` needs `HealthComponent`, look it up in `_ready()` or inject it via the parent [11].
- **NEVER treat Godot nodes as pure data** — Nodes provide lifecycle (`_process`) and signals. If you only need data, use a `Resource`.
- **NEVER ignore the Node lifecycle in components** — Use `_enter_tree()` and `_exit_tree()` for setup/cleanup that must happen regardless of the parent's state.
- **NEVER hide component points of access** — Expose `NodePath` or `Callable` properties so the parent can wire the component in the Inspector [13].

---

## Implementation Standards

### 1. Connection Strategy: Typed Exports
Do not rely on tree order. Use explicit dependency injection via `@export` with static typing.

**The "Godot Way" for strict godot-composition:**
```gdscript
# The Orchestrator (e.g., player.gd)
class_name Player extends CharacterBody3D

# Dependency Injection: Define the "slots" in the backpack
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var input_component: InputComponent

# Use Scene Unique Names (%) for auto-assignment in Editor
# or drag-and-drop in the Inspector.
```

### 2. Component Mindset
Components must define `class_name` to be recognized as types.

**Standard Component Boilerplate:**
```gdscript
class_name MyComponent extends Node 
# Use Node for logic, Node3D/2D if it needs position

@export var stats: Resource # Components can hold their own data
signal happened_something(value)

func _ready() -> void:
    _validate_dependencies()

func _validate_dependencies() -> void:
    # 2. Dependency-Validation: Fail early during development if setup is wrong [2]
    # NOTE: assert() is stripped in release builds [10].
    assert(stats != null, "Stats Resource missing on %s" % name)

func do_logic(delta: float) -> void:
    # Perform specific task
    pass
```

---

## Standard Components — Use Scripts

> Inline Input/Movement/Health recipes removed. **MANDATORY**: start from [composition_root_init.gd](scripts/composition_root_init.gd), then load the matching script:

- Health / death: [health_component.gd](scripts/health_component.gd)
- Damage areas: [hit_box_component.gd](scripts/hit_box_component.gd), [hurt_box_component.gd](scripts/hurt_box_component.gd)
- Motion: [velocity_component.gd](scripts/velocity_component.gd)
- Interact / follow / VFX sync: [interaction_component.gd](scripts/interaction_component.gd), [follower_component.gd](scripts/follower_component.gd), [visual_sync_component.gd](scripts/visual_sync_component.gd)
- States / statuses: [state_component_vsm.gd](scripts/state_component_vsm.gd), [status_effect_component.gd](scripts/status_effect_component.gd)

Typed `@export` wiring stays under **Implementation Standards** above.

## Expert Composition Patterns


### 1. State-Component Pattern (FSM)
Encapsulate complex behaviors into child nodes that act as states. The parent StateComponent delegates lifecycle calls to the active child [4, 6].

> **MANDATORY**: Read [state_component_vsm.gd](scripts/state_component_vsm.gd) — do not paste an inline StateMachine. For deeper VSM / hierarchical FSMs, open [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md).

### 2. Component-Registry (O(1) Lookup)
Avoid slow tree traversal for sibling communication. Catalog children in a Dictionary at ready (by name or group).

```gdscript
var _components: Dictionary = {}

func _ready() -> void:
    for child in get_children():
        _components[child.name] = child
        for group in child.get_groups():
            _components[group] = child

func get_comp(key: StringName) -> Node:
    return _components.get(key)
```

### 3. Dependency-Validation
Fail fast with **`@export` asserts**, not `get_node_or_null` paths (paths break when the tree is rearranged).

```gdscript
@export var health_component: HealthComponent
@export var input_component: InputComponent

func _ready() -> void:
    assert(health_component != null, "Missing HealthComponent export!")
    assert(input_component != null, "Missing InputComponent export!")
```

## Performance Note
Nodes are lightweight. Do not fear adding 10-20 nodes per entity. The organizational benefit of Composition vastly outweighs the negligible memory cost of `Node` instances.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Canonical signal-up / call-down ownership so orchestrators wire components without sibling hard-coupling.
- [Nodes and Scenes](https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html) — Why Godot treats nodes as reusable building blocks (components) assembled into entity scenes.
- [What are Godot classes](https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html) — Prefer scene composition and `class_name` components over deep inheritance trees for gameplay entities.
- [When and how to avoid using nodes for everything](https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html) — Keep pure data in Resources; reserve Nodes for lifecycle, signals, and process ticks.
- [Logic preferences](https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html) — Placement of game logic across scene trees so parents orchestrate and children stay single-purpose.
- [Data preferences](https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html) — Choose Node vs Resource vs plain data for stats and config that components consume.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Past-tense component events (`health_depleted`, `state_changed`) parents connect without reverse dependencies.
- [GDScript exported properties](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — Typed `@export` slots for Inspector dependency injection instead of brittle `$` paths.
- [Scene Unique Nodes](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html) — `%Name` lookups that survive scene-tree reorders when wiring composition roots.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Tag components for O(1)-style registry / interface-like lookup without inheritance.
- [Godot notifications](https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html) — Safe `_ready` / enter-tree timing for validating and connecting component dependencies.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Share tunables (max health, speeds) as Resources so components stay reusable across entities.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Scene ownership, project layout, and Inspector wiring conventions every composition root assumes.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — `class_name`, typed `@export`, Callables, and assert patterns required for typed component APIs.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Signal-up / call-down connect hygiene so selfish components never grab parent scripts.

#### Complements
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Stats and effect definitions as Resources; composition nodes own runtime mutation and emit change events.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Child-node FSM / VSM patterns that plug in as a StateComponent without bloating the orchestrator.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Sense-layer InputComponents that only sample actions; parents pass directions into movement components.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Physics-body movement APIs VelocityComponents and composition roots call via `move_and_slide`.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Area2D layers/masks and overlap rules HitBox/HurtBox/Interaction components depend on.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Spawn/despawn entities as composed scenes and re-wire exports when instances are swapped.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage pipelines assemble Health/HitBox/HurtBox components under combat orchestrators.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Abilities attach as composed workers (cooldowns, targeting) rather than subclassing every caster.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Stat sheets feed Health/StatusEffect components as Resources plus change signals.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate tunable component exports (HP, damage, speeds) before locking entity kits.
- [godot-composition-apps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md) — Same Has-A node composition applied to tools/apps rather than gameplay entities.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting architecture concern.
