---
name: godot-genre-sports
description: "Expert blueprint for sports games (FIFA, NBA 2K, Rocket League, Tony Hawk) covering physics-based ball interaction, team AI formations, contextual input, and match umpire/score authority. Broadcast framing routes to godot-camera-systems. Use when building soccer, basketball, hockey, racing sports, or arcade sports games. Keywords ball physics, magnus effect, formation AI, team tactics, contextual controls, steering behaviors."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Sports

## NEVER Do (Expert Anti-Patterns)

### Physics & Ball Interaction
- NEVER parent the ball directly to a player Transform; strictly keep it a standalone `RigidBody3D` and use `apply_central_impulse()` for **realistic dribble physics**.
- NEVER allow the ball to "Tunnel" through goals; strictly enable **Continuous CD** (`continuous_cd = true`) on the ball's properties for high-velocity validation.
- NEVER scale a `CollisionShape3D` non-uniformly; strictly adjust the resource radius to preserve the internal **moment of inertia**.
- NEVER apply impulses in `_process()`; strictly use `_physics_process()` or `_integrate_forces()` to prevent visual jitter.
- NEVER use a single collision shape for characters; strictly use **layered shapes** for Head, Torso, and Legs to enable headers and chest-traps.

### Match & Team AI
- NEVER allow all AI to chase the ball ("Kindergarten Soccer"); strictly implement **Formation Slots** (Defense/Attack) where only the closest 1-2 players engage.
- NEVER use perfect goalkeeper reflexes; strictly add a **Reaction Delay** (0.2s-0.5s) and an "Error Rate" based on shot angle and velocity.
- NEVER ignore **Root Motion** for movement; strictly use `AnimationTree` with root motion to ensure momentum and turns are visually grounded.
- NEVER trust client-side goal validations; strictly require the **Authoritative Server** to validate physics and score logic.

### Implementation & Sync
- NEVER rely on the default physics tick rate (60 TPS) for fast-moving ballistics; strictly increase **physics_ticks_per_second** (e.g., to 120 or 240) to prevent tunneling.
- NEVER leave **Physics Interpolation** disabled if you want broadcast-quality smoothness; enable it in Project Settings to smooth ball transforms between ticks on high-refresh monitors.
- NEVER skip **vector normalization** on joystick input; strictly normalize to prevent diagonal movement from being 1.4x faster.
- NEVER handle contextual buttons with `is_action_pressed()`; strictly use a **ContextManager** to determine if Button A means "Pass", "Tackle", or "Switch".
- NEVER evaluate an `Area3D` goal trigger immediately; strictly `await get_tree().physics_frame` to allow the Physics Server to sync.

## Ball Possession Decision Tree

| Feel | Approach | Rule |
|------|----------|------|
| **Arcade / magnetic** | Soft follow or short-range spring toward feet | Still **never** reparent the ball to the player Transform; keep `RigidBody3D` authoritative |
| **Sim / impulse dribble** | Kick slightly ahead with `apply_central_impulse()` each touch | Prefer **MANDATORY** ball scripts below; enable `continuous_cd` |

Default for this skill: **impulse dribble**. Magnetic stickiness is a last resort for pure arcade genres and must remain a free RigidBody.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY** — read the script that matches the task before coding:
> - Goals / match phases → [sports_umpire_logic.gd](scripts/sports_umpire_logic.gd)
> - Full flight model (drag + Magnus via `_integrate_forces`) → [sports_ball_physics.gd](scripts/sports_ball_physics.gd)
> - Lean Magnus-only curve (simpler attach) → [magnus_ball_physics.gd](scripts/magnus_ball_physics.gd) — choose **one** ball script, not both
> - Formations / kindergarten-soccer fix → [team_manager.gd](scripts/team_manager.gd)
> - Temporary buffs / powerups → [stat_modifier_powerup.gd](scripts/stat_modifier_powerup.gd)
> - Shared impulse/score helpers → [sports_patterns.gd](scripts/sports_patterns.gd)
>
> **Broadcast camera**: not implemented in this skill’s `scripts/`. Use peer [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) for broadcast framing / zoom-on-action.
>
> **Do NOT Load** every sports script for one task.

### Ball Physics (pick one)
- [sports_ball_physics.gd](scripts/sports_ball_physics.gd) - High-fidelity Magnus + air drag via custom integrator (`continuous_cd` ready).
- [magnus_ball_physics.gd](scripts/magnus_ball_physics.gd) - Leaner Magnus-only force helper when drag is handled elsewhere.

### Match / Team / Meta
- [sports_umpire_logic.gd](scripts/sports_umpire_logic.gd) - Goal Area3D + match state machine (PRE_GAME / ACTIVE / POST_GOAL).
- [team_manager.gd](scripts/team_manager.gd) - Formation Slots and team strategy switching.
- [stat_modifier_powerup.gd](scripts/stat_modifier_powerup.gd) - Temporary player/stat modifiers for arcade powerups.
- [sports_patterns.gd](scripts/sports_patterns.gd) - Physics-safe impulses and authoritative scoring helpers.

---

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Physics | `godot-physics-3d` | Ball bounce, friction, player collisions |
| 2. AI | `godot-state-machine-advanced`, `godot-navigation-pathfinding` | Formations, marking, avoidance |
| 3. Anim | `godot-animation-tree-mastery` | Blended running, shooting, tackling |
| 4. Input | `godot-input-handling` | Contextual buttons (Pass/Tackle share button) |
| 5. Camera | `godot-camera-systems` | Broadcast view / zoom-on-action (**peer skill**, not local scripts) |

## Architecture Overview

### 1. The Ball (Physics Core)
The most important object. Must feel right.

```gdscript
# ball.gd
extends RigidBody3D

@export var drag_coefficient: float = 0.5
@export var magnus_effect_strength: float = 2.0

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
    # Apply Air Drag
    var velocity = state.linear_velocity
    var speed = velocity.length()
    var drag_force = -velocity.normalized() * (drag_coefficient * speed * speed)
    state.apply_central_force(drag_force)
    
    # Magnus Effect (Curve)
    var spin = state.angular_velocity
    var magnus_force = spin.cross(velocity) * magnus_effect_strength
    state.apply_central_force(magnus_force)
```

### 2. Team AI (Formations)
AI players don't just run at the ball. They run to *positions* relative to the ball/field.

```gdscript
# team_manager.gd
extends Node

enum Strategy { ATTACK, DEFEND }
var current_strategy: Strategy = Strategy.DEFEND
var formation_slots: Array[Node3D] # Markers parented to a "Formation Anchor"

func update_tactics(ball_pos: Vector3) -> void:
    # Move the entire formation anchor
    formation_anchor.position = lerp(formation_anchor.position, ball_pos, 0.5)
    
    # Assign best player to each slot
    for player in players:
        var best_slot = find_closest_slot(player)
        player.set_target(best_slot.global_position)
```

### 3. Match Manager
The referee logic.

```gdscript
# match_manager.gd
var score_team_a: int = 0
var score_team_b: int = 0
var match_timer: float = 300.0
enum State { KICKOFF, PLAYING, GOAL, END }

func goal_scored(team: int) -> void:
    if team == 0: score_team_a += 1
    else: score_team_b += 1
    current_state = State.GOAL
    play_celebration()
    await get_tree().create_timer(5.0).timeout
    reset_positions()
    current_state = State.KICKOFF
```

## Key Mechanics Implementation

### Contextual Input
"A" button does different things depending on context.

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("action_main"):
        if has_ball:
            pass_ball()
        elif is_near_ball:
            slide_tackle()
        else:
            switch_player()
```

### Steering Behaviors
For natural movement (Seek, Flee, Arrive).

```gdscript
func seek(target_pos: Vector3) -> Vector3:
    var desired_velocity = (target_pos - global_position).normalized() * max_speed
    var steering = desired_velocity - velocity
    return steering.limit_length(max_force)
```

## Godot-Specific Tips

*   **NavigationServer3D**: Essential for avoiding obstacles (other players/referee).
*   **AnimationTree (BlendSpace2D)**: Crucial for sports. You need smooth blending between Idle -> Walk -> Jog -> Sprint in all directions.
*   **PhysicsMaterial**: Tune `bounce` and `friction` on the Ball and Field colliders carefully.

## Common Pitfalls

1.  **AI Bunching**: All 22 players running at the ball (Kindergarten Soccer). **Fix**: Use Formation Slots. Only 1-2 players "Press" the ball; others cover space.
2.  **Magnetic Ball**: Ball sticks to player too perfectly. **Fix**: Use a "Dribble" mechanic where the player kicks the ball slightly ahead physics-wise, rather than parenting it.
3.  **Unfair Goalies**: Goalie reacts instantly. **Fix**: Add a "Reaction Time" delay and "Error Rate" based on shot speed/stats.


## Advanced Sports Meta-Systems

Professional implementation of animation synchronization, spatial intelligence, and collision filtering.

### 1. Root-Motion-Transition (AnimationTree)
Utilize the `AnimationMixer` class (and its derivatives like `AnimationTree`) to extract root motion from complex animations. This ensures that the character's physical displacement is driven directly by the animation data, preventing "skating" and ensuring momentum is visually grounded during high-speed turns or shots.

```gdscript
class_name SportsCharacter extends CharacterBody3D

@onready var anim_tree: AnimationTree = $AnimationTree

func _physics_process(_delta: float) -> void:
    # Extract root motion from the current animation state
    var root_motion := anim_tree.get_root_motion_position()
    # Apply to velocity for physics-synced movement
    velocity = (global_transform.basis * root_motion) / _delta
    move_and_slide()
```

### 2. Contextual-Pass-Prediction (Raycasts)
To predict if a passing lane is clear, configure a `PhysicsRayQueryParameters3D` object and use `PhysicsDirectSpaceState3D.intersect_ray()`. This allows the AI or player assist to verify unobstructed paths to teammates before committing to an action.

```gdscript
class_name PassPredictor extends Node3D

func is_lane_clear(target_pos: Vector3) -> bool:
    var space_state := get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(global_position, target_pos)
    query.collision_mask = 1 # Environment/Opponents
    
    var result := space_state.intersect_ray(query)
    return result.is_empty() # Path is clear if no collision
```

### 3. Layered-Hitbox Pattern
Configure `Area3D` nodes with specific `collision_layer` and `collision_mask` properties to filter interactions. By assigning different layers for the ball and specific body parts (Head, Torso, Legs), you can accurately detect contextual overlaps for headers, chest-traps, or slide tackles.

```gdscript
class_name BodyPartHitbox extends Area3D

enum Part { HEAD, TORSO, LEGS }
@export var part_type: Part

func _on_ball_entered(ball: RigidBody3D) -> void:
    match part_type:
        Part.HEAD:
            apply_header_force(ball)
        Part.TORSO:
            apply_chest_trap(ball)
        Part.LEGS:
            apply_kick_force(ball)
```

**Expert Tip**: For the "Root Motion" system, ensure the `AnimationTree` property `deterministic` is set to true to ensure consistent displacement across different hardware.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Collision layers/masks, continuous CD, and when RigidBody vs CharacterBody fits sports players and balls.
- [Using RigidBody](https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html) — Impulse/force timing, custom integrators, and contact monitoring for kick/dribble without parenting the ball.
- [RigidBody3D](https://docs.godotengine.org/en/stable/classes/class_rigidbody3d.html) — `continuous_cd`, damp, and `apply_central_impulse` / force APIs for high-speed ballistics.
- [PhysicsDirectBodyState3D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectbodystate3d.html) — `_integrate_forces` state for Magnus/drag custom forces without fighting the solver.
- [PhysicsMaterial](https://docs.godotengine.org/en/stable/classes/class_physicsmaterial.html) — Bounce/friction overrides for ball and pitch surfaces.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — Correct sphere/capsule sizing so inertia and layered hitboxes stay physically valid.
- [Physics interpolation](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Broadcast-smooth ball/player transforms between elevated physics ticks.
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Keep impulses and match rules in `_physics_process` / integrate paths to avoid jitter.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Pass-lane and tackle assist queries via `PhysicsDirectSpaceState3D`.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — BlendSpace locomotion and root-motion extraction for grounded cuts and shots.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Normalized stick axes, device IDs, and vibration for contextual Pass/Tackle/Switch.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Authoritative goal validation and unreliable movement sync for competitive matches.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoloads, physics tick/interpolation project settings, and scene layout before ball/team systems land.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — RigidBody3D, layers/masks, and continuous collision patterns the ball and layered hitboxes depend on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Action maps and device routing so one button can mean Pass, Tackle, or Switch by context.

#### Complements
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — Root-motion BlendSpaces and deterministic mixer setup for sprint/shot/tackle without skating.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Broadcast framing, zoom-on-action, and follow rigs for pitch-scale presentation.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent/mesh avoidance so formation runners do not stack through teammates.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Match phases (kickoff/play/goal/end) and per-player chase vs formation states.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Masked space queries for clear passing lanes and tackle prediction.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Server-authoritative score RPCs and transfer modes for fast sports snapshots.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Authority split and reconciliation when promoting local kickabouts to online matches.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Goal, possession, and UI event buses without coupling umpire logic to every player node.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Stadium collision, pitch surfaces, and LOD props around the playable field.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate player/attribute asymmetry, keeper reaction error bands, and rubber-band AI so match outcomes stay competitive.
- [godot-genre-racing](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md) — Adjacent high-speed physics genre patterns when the sport leans vehicle/arcade (e.g. Rocket League-style).

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting sports concern.
