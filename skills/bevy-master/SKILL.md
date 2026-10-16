---
name: bevy-master
description: "Bevy ECS hub for Bevy 0.20+. Use when starting a Bevy game, choosing ECS boundaries, or picking a Bevy skill. Keywords: Bevy, ECS, bevy-master, schedules, plugins."
---

# Bevy Master: ECS hub

ECS hub for Bevy 0.20+. Start here to set up a Bevy app, decide which components, resources, and systems own each piece of state, and load the right Bevy skill for the job.

## Library target

Target: **Bevy 0.20+** (tested against 0.20.0).

## Who owns what (ECS)

For every piece of state, name:

- which **component** or **resource** owns it
- which **system** may mutate it
- which message or observer should observe it

Schedules replace a scene tree. Do not add an autoload, a signal bus, or a Node layer cake.

The Quick Start ECS page defines entities, components (`Component`), systems as functions, `Query`, `Commands`, `Startup`, and `Update`, plus `.chain()` for order. Messages, observers, resources, and app states are covered in their own skills. See those files before calling a type.

## Routing

| Scenario | Route |
| --- | --- |
| New Bevy app, ECS boundaries, which skill to load | This hub, then the module directory below |
| New crate, Cargo features, feature folders | [bevy-project-foundations](references/project-foundations.md) |
| Artifact ledger into a Bevy crate | [gdas-reader](references/gdas-reader.md) then [bevy-rea](references/rea.md) |
| Entity composition, components, systems | [bevy-ecs-composition](references/ecs-composition.md) |
| Messages, events, observers | [bevy-events-messaging](references/events-messaging.md) |
| Components and resources as data | [bevy-data-resources](references/data-resources.md) |
| App states or a per-entity mode flag | [bevy-state-machines](references/state-machines.md) |
| App-wide resources and schedules | [bevy-app-resources](references/app-resources.md) |
| Character movement | [bevy-character-movement](references/character-movement.md) |
| 3D physics | [bevy-physics-3d](references/physics-3d.md) |
| 2D physics | [bevy-physics-2d](references/physics-2d.md) |
| Ray, overlap, or physics pick | [bevy-spatial-queries](references/spatial-queries.md) |
| Navigation mesh or path data | [bevy-navigation](references/ai-navigation.md) |
| Chase, patrol, retarget | [bevy-ai-navigation](references/ai-navigation.md) |
| Seeded level or loot layout | [bevy-procedural-generation](references/procedural-generation.md) |
| Keyboard, mouse, gamepad | [bevy-input-handling](references/input-handling.md) |
| 2D or 3D camera entity | [bevy-camera-systems](references/camera-systems.md) |
| Play or control a clip | [bevy-audio-systems](references/audio-systems.md) |
| Load assets or spawn a scene | [bevy-asset-scenes](references/asset-scenes.md) |
| Player save slot | [bevy-save-load](references/save-load.md) |
| Logs and frame diagnostics | [bevy-debugging-profiling](references/debugging-profiling.md) |
| Parallelism, fixed step, handle lifetime | [bevy-performance](references/performance.md) |
| `cargo test` | [bevy-testing-patterns](references/testing-patterns.md) |
| Clips, blend graphs, sprites, lights, materials, UI, or a genre loop | Module directory below |

## When not to spawn an entity

Data that is not simulated can be a plain Rust struct or a resource. The Quick Start treats resources as app-wide data. A score or a seed is one `Resource` inserted at startup. Do not copy a Godot Object / RefCounted / Resource / Node table into Bevy.

## Workflows

**(a) App scaffold.** `App::new()`, plugins, schedules, and states. The plugins page documents `Plugin`, `DefaultPlugins`, `MinimalPlugins`, and `add_plugins`. The `bevy` 0.20.0 crate docs list a `bevy_state` feature ("built in global state machines"). `States`, `init_state`, and `OnEnter` are the state API. Do not invent a plugin list beyond `DefaultPlugins` / `MinimalPlugins`.

**(b) Entity.** Components plus systems. Movement belongs on a fixed timestep. `bevy::time` 0.20.0 documents `Fixed` ("fixed timestep game clock") and `run_fixed_main_schedule` (`FixedMain`). Do not invent a schedule label beyond those names.

**(c) Data.** Components and resources. Not `.tres` files.

**(d) Performance.** The ECS page states systems run in parallel by default when they can, and `.chain()` forces order. Frame-time diagnostics and handle lifetimes are on `bevy-performance`. No numeric budget is stated on those pages.

## Examples

```toml
[package]
name = "bevy-app"
version = "0.1.0"
edition = "2021"

[dependencies]
bevy = "0.20"
```

A new app adds `DefaultPlugins`, inserts one resource, and spawns the player on startup.

```rust
#[derive(Resource)]
struct Score(u32);

#[derive(Component)]
struct Player;

fn spawn_player(mut commands: Commands) {
    commands.insert_resource(Score(0));
    commands.spawn((Player, Transform::from_xyz(0.0, 0.0, 0.0)));
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, spawn_player)
        .run();
}
```

Input writes velocity. Movement writes `Transform`. They share `Player` data, so they are chained on `FixedUpdate`.

```rust
#[derive(Component)]
struct Velocity(Vec2);

fn read_input(
    keys: Res<ButtonInput<KeyCode>>,
    mut players: Query<&mut Velocity>,
) {
    for mut velocity in &mut players {
        let mut dir = Vec2::ZERO;
        if keys.pressed(KeyCode::KeyA) {
            dir.x -= 1.0;
        }
        if keys.pressed(KeyCode::KeyD) {
            dir.x += 1.0;
        }
        if keys.pressed(KeyCode::KeyW) {
            dir.y += 1.0;
        }
        if keys.pressed(KeyCode::KeyS) {
            dir.y -= 1.0;
        }
        velocity.0 = dir.normalize_or_zero() * 4.0;
    }
}

fn apply_velocity(
    time: Res<Time<Fixed>>,
    mut players: Query<(&Velocity, &mut Transform)>,
) {
    let dt = time.delta_secs();
    for (velocity, mut transform) in &mut players {
        transform.translation.x += velocity.0.x * dt;
        transform.translation.y += velocity.0.y * dt;
    }
}

pub struct MovementPlugin;

impl Plugin for MovementPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(FixedUpdate, (read_input, apply_velocity).chain());
    }
}
```

`AppState` is a global state. Entering `Playing` runs the spawn system once.

```rust
#[derive(States, Debug, Clone, PartialEq, Eq, Hash, Default)]
enum AppState {
    #[default]
    Loading,
    Playing,
}

#[derive(Component)]
struct Player;

fn enter_playing(mut commands: Commands) {
    commands.spawn((Player, Transform::from_xyz(0.0, 0.0, 0.0)));
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .init_state::<AppState>()
        .add_systems(OnEnter(AppState::Playing), enter_playing)
        .run();
}
```

## Expert Knowledge Delta

Target: **Bevy 0.20+**.

Core ECS types: `Component`, `Resource`, `Query`, `Commands`, `Startup`, `Update`, `Fixed` / `FixedMain` (`bevy::time`), `.chain()`, `Plugin`, `DefaultPlugins`, `MinimalPlugins`. Messages and observers are an ownership slot. See `bevy-events-messaging` for their APIs. Systems run in parallel unless `.chain()` orders the ones that conflict.

### Who owns state

| Piece | Owner | Who may mutate | Schedule |
| --- | --- | --- | --- |
| Data on one entity | `Component` | One system via `Query` | `Update` or `FixedMain` |
| One value for the whole app | `Resource` | One system | `Startup` to insert, then the schedule that reads it |
| Spawn | `Commands` | The spawning system | `Startup` for the initial world; later schedules for runtime spawn |
| Order that must not race | `.chain()` | The chained systems only | Same schedule |
| Plugin boundary | `Plugin` | `build` registers systems and resources | Before the app runs |

Borrow rule: two systems that both mutably query the same component must be ordered (`.chain()`) or split so only one writes. Unrelated systems stay parallel. That is the ECS page rule, not a guess at a system-set API.

### Decision

| If you need | Do this | Do not |
| --- | --- | --- |
| Per-entity data | `Component` + `Query` | A Godot node script |
| App-wide config or clock | `Resource` | Copy the value onto every entity |
| Stable simulation step | `FixedMain` and the `Fixed` clock | Tie simulation to raw frame `Update` |
| Startup spawn | `Commands` in `Startup` | Spawn from a render system |
| Cross-system notice that is not shared state | Message or observer slot in `bevy-events-messaging` | A new event type invented in this file |
| An API outside the documented set | Check the official docs first | A made-up crate or API |

Load [references/ecs-ownership.md](references/2d-animation-ecs-ownership.md) for the ownership table.

## NEVER

- Do not pin `/0.20.0/` in docs URLs. WHY: links stay on `latest`; the 0.20 target is stated once in prose.
- Do not mutably query the same component from two unordered systems. WHY: the schedule runs systems in parallel unless `.chain()` orders them.
- Do not invent a physics, navigation, networking, or XR crate here. WHY: this skill only names documented Bevy crates and modules.

- No Godot or gdext type imports in Bevy code. WHY: Bevy code stays idiomatic ECS and uses only documented Bevy APIs.
- No GDScript line-translate. WHY: Bevy code stays idiomatic ECS and uses only documented Bevy APIs.
- No APIs that this file did not open. WHY: Bevy code stays idiomatic ECS and uses only documented Bevy APIs.
- No Coil or Ouroboros UI. WHY: Bevy code stays idiomatic ECS and uses only documented Bevy APIs.

## Module directory

Domain skills:

- [bevy-project-foundations](references/project-foundations.md)
- [gdas-reader](references/gdas-reader.md)
- [bevy-rea](references/rea.md)
- [bevy-ecs-composition](references/ecs-composition.md)
- [bevy-events-messaging](references/events-messaging.md)
- [bevy-data-resources](references/data-resources.md)
- [bevy-state-machines](references/state-machines.md)
- [bevy-app-resources](references/app-resources.md)
- [bevy-character-movement](references/character-movement.md)
- [bevy-physics-3d](references/physics-3d.md)
- [bevy-physics-2d](references/physics-2d.md)
- [bevy-spatial-queries](references/spatial-queries.md)
- [bevy-navigation](references/ai-navigation.md)
- [bevy-ai-navigation](references/ai-navigation.md)
- [bevy-procedural-generation](references/procedural-generation.md)
- [bevy-input-handling](references/input-handling.md)
- [bevy-camera-systems](references/camera-systems.md)
- [bevy-audio-systems](references/audio-systems.md)
- [bevy-asset-scenes](references/asset-scenes.md)
- [bevy-save-load](references/save-load.md)
- [bevy-debugging-profiling](references/debugging-profiling.md)
- [bevy-performance](references/performance.md)
- [bevy-testing-patterns](references/testing-patterns.md)

Rendering and animation:

- [bevy-2d-animation](references/2d-animation.md)
- [bevy-animation](references/2d-animation.md)
- [bevy-animation-graph](references/animation-graph.md)
- [bevy-particles](references/particles.md)
- [bevy-shaders](references/shaders.md)
- [bevy-tilemap](references/tilemap.md)
- [bevy-tweening](references/tweening.md)
- [bevy-3d-lighting](references/3d-lighting.md)
- [bevy-3d-materials](references/3d-materials.md)
- [bevy-3d-world-building](references/3d-world-building.md)

Gameplay:

- [bevy-ability-system](references/ability-system.md)
- [bevy-combat-system](references/combat-system.md)
- [bevy-dialogue-system](references/dialogue-system.md)
- [bevy-economy-system](references/economy-system.md)
- [bevy-game-loop-collection](references/game-loop-collection.md)
- [bevy-game-loop-harvest](references/game-loop-harvest.md)
- [bevy-game-loop-time-trial](references/game-loop-time-trial.md)
- [bevy-game-loop-waves](references/game-loop-waves.md)
- [bevy-inventory-system](references/inventory-system.md)
- [bevy-mechanic-revival](references/mechanic-revival.md)
- [bevy-mechanic-secrets](references/mechanic-secrets.md)
- [bevy-quest-system](references/quest-system.md)
- [bevy-rpg-stats](references/rpg-stats.md)
- [bevy-turn-system](references/turn-system.md)

UI, platforms, adapts, templates:

- [bevy-ui-layout](references/ui-layout.md)
- [bevy-ui-text](references/ui-text.md)
- [bevy-ui-theming](references/ui-theming.md)
- [bevy-platform-desktop](references/platform-desktop.md)
- [bevy-platform-web](references/platform-web.md)
- [bevy-platform-mobile](references/platform-mobile.md)
- [bevy-adapt-2d-to-3d](references/adapt-2d-to-3d.md)
- [bevy-adapt-3d-to-2d](references/adapt-3d-to-2d.md)
- [bevy-adapt-desktop-to-mobile](references/adapt-desktop-to-mobile.md)
- [bevy-adapt-mobile-to-desktop](references/adapt-mobile-to-desktop.md)
- [bevy-project-templates](references/project-templates.md)

Genre routers:

- [bevy-genre-action-rpg](references/genre-action-rpg.md)
- [bevy-genre-fighting](references/genre-fighting.md)
- [bevy-genre-platformer](references/genre-platformer.md)
- [bevy-genre-shooter](references/genre-shooter.md)
- [bevy-genre-shooter-fps](references/genre-shooter-fps.md)
- [bevy-genre-rts](references/genre-rts.md)
- [bevy-genre-tower-defense](references/genre-tower-defense.md)
- [bevy-genre-metroidvania](references/genre-metroidvania.md)
- [bevy-genre-open-world](references/genre-open-world.md)
- [bevy-genre-roguelike](references/genre-roguelike.md)
- [bevy-genre-survival](references/genre-survival.md)
- [bevy-genre-card-game](references/genre-card-game.md)
- [bevy-genre-educational](references/genre-educational.md)
- [bevy-genre-horror](references/genre-horror.md)
- [bevy-genre-puzzle](references/genre-puzzle.md)
- [bevy-genre-visual-novel](references/genre-visual-novel.md)
- [bevy-genre-romance](references/genre-romance.md)
- [bevy-genre-idle-clicker](references/genre-idle-clicker.md)
- [bevy-genre-party](references/genre-party.md)
- [bevy-genre-racing](references/genre-racing.md)
- [bevy-genre-rhythm](references/genre-rhythm.md)
- [bevy-genre-sandbox](references/genre-sandbox.md)
- [bevy-genre-simulation](references/genre-simulation.md)
- [bevy-genre-sports](references/genre-sports.md)
- [bevy-genre-stealth](references/genre-stealth.md)


## Reference



### Official Documentation
- `bevy crate`  -  Unversioned API index. Feature samples on the pinned page may still show older version strings.
- [Assets](https://bevy.org/assets/)  -  Official asset catalog.
- [Examples](https://github.com/bevyengine/bevy/tree/latest/examples#examples)  -  Example tree on the `latest` branch, not a release tag.
- [Quick Start](https://bevy.org/learn/quick-start/)  -  Guide index. The legacy `/learn/book/` path returned 404 on 2026-10-11.
- [Getting started](https://bevy.org/learn/quick-start/getting-started/)  -  App setup before ECS and plugins.
- [ECS](https://bevy.org/learn/quick-start/getting-started/ecs/)  -  Entities, components, systems, `Query`, `Commands`, `Startup`, `Update`, and `.chain()`.
- [Plugins](https://bevy.org/learn/quick-start/getting-started/plugins/)  -  `Plugin`, `DefaultPlugins`, `MinimalPlugins`, and `add_plugins`.
- `bevy::time`  -  `Fixed` and `run_fixed_main_schedule` (`FixedMain`).
- [crates.io bevy](https://crates.io/crates/bevy)  -  Release pin source (0.20.0, 2026-10-08).

### Related Skills

#### Prerequisites
- None. This hub is the Bevy entry point.

#### Complements
- [godot-master](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/godot-master/SKILL.md)  -  Godot hub.

#### Downstream / consumers
- [bevy-project-foundations](references/project-foundations.md)  -  Crate, Cargo features, and layout habits.
- [bevy-ecs-composition](references/ecs-composition.md)  -  Components, spawn tuples, queries, and `.chain()`.
- [bevy-events-messaging](references/events-messaging.md)  -  `Message` readers and `Event` observers.
- [bevy-data-resources](references/data-resources.md)  -  `Component` versus `Resource`.
- [bevy-state-machines](references/state-machines.md)  -  `bevy::state` and per-entity mode flags.
- [bevy-app-resources](references/app-resources.md)  -  App-wide resources and `Startup` / `Update`.
- [bevy-character-movement](references/character-movement.md)  -  Player and actor motion on the fixed timestep.
- [bevy-physics-3d](references/physics-3d.md)  -  Simulated 3D bodies once a solver crate is verified.
- [bevy-physics-2d](references/physics-2d.md)  -  Simulated 2D bodies.
- [bevy-spatial-queries](references/spatial-queries.md)  -  Casts and overlaps. Solver still unpicked.
- [bevy-navigation](references/ai-navigation.md)  -  Path data.
- [bevy-ai-navigation](references/ai-navigation.md)  -  Chase and patrol policy.
- [bevy-procedural-generation](references/procedural-generation.md)  -  Seed resource and spawn. No noise API.
- [bevy-input-handling](references/input-handling.md)  -  `ButtonInput`, mouse, and gamepad.
- [bevy-camera-systems](references/camera-systems.md)  -  `Camera2d` and `Camera3d`.
- [bevy-audio-systems](references/audio-systems.md)  -  `AudioPlayer` and `AudioSink`.
- [bevy-asset-scenes](references/asset-scenes.md)  -  `AssetServer` and `spawn_scene`.
- [bevy-save-load](references/save-load.md)  -  Player save slots. Scene spawn is not a save.
- [bevy-debugging-profiling](references/debugging-profiling.md)  -  `LogPlugin` and diagnostics plugins.
- [bevy-performance](references/performance.md)  -  Parallel systems, fixed step, handle lifetimes.
- [bevy-testing-patterns](references/testing-patterns.md)  -  `cargo test`. Not GdUnit.

#### Master
- This file. Do not route Bevy work through a parent that also owns Godot.

Cipher rule titles only: runtime gameplay is Rust; do not pull Godot types into Bevy crates.

## Scope

- Resources, states, messages, and observers live in their own skills. Call only the types those skills cite. Check the `App` docs for state-installation method names before writing them.
- The getting-started snippet still shows `bevy = "0.19"` while crates.io latest is 0.20.0. Pin **0.20.0** from crates.io and the Bevy API reference, not from that stale snippet.
- Bevy API reference feature examples on the 0.20.0 page still show `version = "0.18"` in one sample. That sample is not the pin.
