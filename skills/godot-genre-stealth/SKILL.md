---
name: godot-genre-stealth
description: "Expert blueprint for stealth games (Splinter Cell, Hitman, Dishonored, Thief) covering AI detection systems, vision cones, sound propagation, alert states, light/shadow mechanics, and systemic design. Use when building stealth-action, tactical infiltration, or immersive sim games requiring enemy awareness systems. Keywords vision cone, detection, alert state, sound propagation, light level, systemic AI, gradual detection."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Stealth

Player choice, systemic AI, and clear communication define stealth games.

## NEVER Do (Expert Anti-Patterns)

### Detection & Awareness
- NEVER use binary "Seen/Not Seen" detection; strictly use a **Gradual Detection Meter** (0-100%) that builds based on distance, light level, and speed.
- NEVER use standard `RayCast3D` nodes for massive amounts of vision checks; strictly use **`PhysicsDirectSpaceState3D.intersect_ray()`** to query the PhysicsServer instantly and nodelessly.
- NEVER allow AI to see through solid geometry; strictly use raycasts between AI eyes and player sample points (Head/Torso/Feet).
- NEVER use a single sample point for visibility; strictly sample **at least 3 points** (Head, Torso, Feet) to prevent detection bugs when partially in cover.
- NEVER use static "Guard Paths"; strictly implement **Dynamic Investigating** where guards leave their route to check on suspicious sounds/activities.
- NEVER trigger "Detection" immediately upon line-of-sight; strictly use a **Detection Meter** with a decay rate to provide a "forgiveness window" for the player to recover.
- NEVER assume a random navmesh point is safe; strictly verify cover points by **Raycasting toward the Threat** to ensure geometry successfully breaks the line of sight.
- NEVER forget to pass the guard's own **RID** into the raycast exclude array; if omitted, the ray will hit the guard's own body, causing false blocking.
- NEVER run complex AI detection for off-screen guards; strictly use `VisibleOnScreenNotifier3D` to pause heavy logic for distant enemies.

### Systemic & World Logic
- NEVER use a simple `distance_to()` check for hearing; strictly calculate sound travel along the **Navigation Path** to determine if a wall blocks noise.
- NEVER make combat as viable as stealth; strictly ensure "going loud" triggers intense reinforcements or high-lethality states to preserve the stealth loop.
- NEVER hide the "Why" of detection; strictly provide immediate feedback via **UI icons (?, !)** or audio barks ("What was that?").
- NEVER ignore the return value of `intersect_ray()`; strictly check `is_empty()` first to prevent runtime crashes.
- NEVER assume a raycast won't hit the guard itself; strictly **exclude the guard's RID** from Query Parameters.

### Optimization & Performance
- NEVER tightly couple AI to player scripts; strictly use **duck-typing** (e.g., `if body.has_method("get_detected")`) so guards can spot decoys or dead bodies without brittle dependencies.
- NEVER maintain hardcoded arrays to trigger base-wide alarms; strictly add guards to a **"guards" group** and use `get_tree().call_group()` for dynamic notification.
- NEVER use standard Strings for AI state; strictly use `StringName` (&"alert") for O(1) pointer-level comparisons in high-frequency loops.
- NEVER bake massive NavigationMeshes synchronously; strictly use `use_async_iterations` to prevent main thread stalls during runtime bakes.
- NEVER rely on `Node.find_child()` during gameplay; strictly use **Groups** or exported references for O(1) player tracking.
- NEVER leave CollisionShapes enabled on incapacitated bodies; strictly disable them or move them to a "corpse" layer to prevent pathing interference.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [stealth_patterns.gd](scripts/stealth_patterns.gd) — space-state LoS, cone DOT, hearing helpers
> 2. [stealth_ai_controller.gd](scripts/stealth_ai_controller.gd) — multi-sample rays + RID exclude + path-length hearing
> 3. [stealth_vision_cone.gd](scripts/stealth_vision_cone.gd) / [vision_cone_3d.gd](scripts/vision_cone_3d.gd) — cone authorship

### Original Expert Patterns
- [stealth_patterns.gd](scripts/stealth_patterns.gd) - Nodeless LoS, cone tests, AI_Audible bus, async investigate.
- [stealth_ai_controller.gd](scripts/stealth_ai_controller.gd) - Alert meter AI using PhysicsDirectSpaceState (not RayCast3D nodes).

### Modular Components
- [stealth_vision_cone.gd](scripts/stealth_vision_cone.gd) - 2D/logic cone helpers.
- [vision_cone_3d.gd](scripts/vision_cone_3d.gd) - 3D cone debug / query helpers.
- [visibility_manager.gd](scripts/visibility_manager.gd) - Player exposure / light gem aggregation.
- [light_detector.gd](scripts/light_detector.gd) - Light probe / overlap exposure.
- [sound_occlusion_manager.gd](scripts/sound_occlusion_manager.gd) - Occlusion / bus routing for AI hearing.

---

## Core Loop
1. **Hide / move** → 2. **Vision & light exposure** → 3. **Sound propagation** → 4. **Alert escalation** → 5. **Investigate / escape**

## Decision Trees

### Perception
| Need | Action |
|------|--------|
| LoS + exclude self/player RIDs | **MANDATORY** [stealth_ai_controller.gd](scripts/stealth_ai_controller.gd) + [stealth_patterns.gd](scripts/stealth_patterns.gd) |
| Light-scaled detection | [visibility_manager.gd](scripts/visibility_manager.gd) / [light_detector.gd](scripts/light_detector.gd) |
| Hearing through geometry | Path-length via NavigationServer (controller) + [sound_occlusion_manager.gd](scripts/sound_occlusion_manager.gd) |

### When to load modules
| Task | Load |
|------|------|
| Guard AI spine | patterns + ai_controller |
| Author cones | vision_cone scripts |
| Player light gem | visibility + light_detector |
| Loud world props | sound_occlusion_manager |

Do **not** paste long vision/alert/ability tutorials into the skill body — keep decision trees here and implement from scripts.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Physics | `godot-raycasting-queries` | Space-state LoS |
| 2. Nav | `godot-navigation-pathfinding` | Investigate / path hearing |
| 3. AI | `godot-state-machine-advanced` | IDLE→ALERT FSM |
| 4. Audio | `godot-audio-systems` | AI_Audible buses |
| 5. Balance | `godot-monte-carlo-balancer` | Detection thresholds |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| RayCast3D per guard | Multi-sample `intersect_ray` + RID exclude |
| `distance_to` hearing | Navigation path length |
| Off-screen CPU | `VisibleOnScreenNotifier` suspend |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Node casts vs PhysicsDirectSpaceState3D.intersect_ray() for many AI LoS checks without RayCast3D spam.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — collision layers/masks that filter vision rays, hearing spheres, and corpse layers.
- [PhysicsDirectSpaceState3D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html) — nodeless intersect_ray / intersect_shape contracts for composite vision and cover verification.
- [PhysicsRayQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html) — mask, exclude RIDs, and collide flags so guards never self-block LoS queries.
- [Lights and shadows](https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html) — Omni/Spot energy and shadows that drive light-gem exposure and shadow-layer hiding.
- [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html) — dedicated AI-audible buses so loud footsteps/impacts route into hearing systems.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — regions, agents, and async bake for patrols and investigate paths.
- [Using navigation paths](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpaths.html) — path length as wall-aware sound travel instead of raw distance_to().
- [NavigationServer3D](https://docs.godotengine.org/en/stable/classes/class_navigationserver3d.html) — map_get_path, random cover points, and avoidance masks for investigating guards.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — guards / player / lights groups and call_group for base-wide alarms without hardcoded arrays.
- [VisibleOnScreenNotifier3D](https://docs.godotengine.org/en/stable/classes/class_visibleonscreennotifier3d.html) — pause heavy detection when off-screen so distant AI do not burn the physics budget.
- [Screen-reading shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html) — hint_screen_texture vision-cone feedback overlays (not Godot 3 SCREEN_TEXTURE).

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, groups, and import/project setup before wiring guards, lights, and player sample points.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — CharacterBody3D, layers/masks, and collision shapes that vision rays and hearing volumes must hit honestly.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — PhysicsServer query parameters, RID excludes, and multi-sample LoS recipes this genre depends on every frame.

#### Complements
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent patrols, investigate targets, and path-length hearing that respects walls.
- [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md) — FOV sensors and perception stacks that feed suspicion/alert state machines.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — 3D streams and bus layouts for AI-audible noise without coupling to player SFX buses.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — light energy, shadows, and probe setups that make light-level detection fair and readable.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — StringName IDLE/SUSPICIOUS/ALERTED/COMBAT machines instead of ad-hoc string compares.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — alert_state_changed and detection-meter signals that keep UI, barks, and AI decoupled.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — screen-space cone tint and outline feedback so players always see why they were spotted.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — lean/peek and frustum-driven VisibleOnScreenNotifier suspend for off-screen guard budgets.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate detection rates, FOV ranges, hearing falloff, and forgiveness windows before shipping difficulty.

#### Downstream / consumers
- [godot-genre-horror](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md) — stalker cones, hiding spots, and suspicion meters that reuse sensory AI patterns.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — lethal escalation and takedown windows once ALERTED/COMBAT breaks the stealth loop.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
