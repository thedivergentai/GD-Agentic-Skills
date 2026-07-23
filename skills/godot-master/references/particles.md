---
name: godot-particles
description: "Expert blueprint for GPU particle systems (explosions, magic effects, weather, trails) using GPUParticles2D/3D, ParticleProcessMaterial, gradients, sub-emitters, and custom shaders. Use when creating VFX, environmental effects, or visual feedback. Keywords GPUParticles2D, ParticleProcessMaterial, emission_shape, color_ramp, sub_emitter, one_shot."
---
## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Particle Systems

GPU-accelerated VFX with material-driven emission, recyclers, and MultiMesh swarms — not beginner effect recipes.

## NEVER Do in Particle Systems

- **NEVER use `amount_ratio` to optimize performance dynamically** — It does not save GPU memory or improve processing; the full `amount` is still allocated. Change the `amount` property directly instead.
- **NEVER use CPUParticles2D for performance-critical effects on Desktop** — Use GPUParticles unless targeting low-end mobile with no GPU support. However, use CPUParticles2D if you need Physics Interpolation for smooth trails on moving bodies in 2D.
- **NEVER set `preprocess` to extremely high values** — High values (e.g., 60s) will force the GPU to simulate thousands of frames in a single render tick, potentially causing an immediate GPU crash.
- **NEVER leave `visibility_aabb` unconfigured for large systems** — Incorrect AABBs cause frustum culling errors (particles popping out) and break LOD calculations. Generate AABBs using the editor toolbar.
- **NEVER enable turbulence on Mobile/Web without testing** — 3D noise evaluation per particle is extremely heavy. Disable via Feature Tags on lower-end platforms.
- **NEVER use a Timer to lifetime-cleanup one-shots** — Prefer [smart_oneshot_recycler.gd](../scripts/particles_smart_oneshot_recycler.gd): `finished` + `restart()`, or `queue_free()` only on truly disposable instances.
- **NEVER use `local_coords = true` for trails** — Smoke or fire left behind by a projectile MUST use global space (`local_coords = false`) or the trail will follow the projectile like a stiff stick.
- **NEVER expect GPUParticles2D to interpolate correctly in Godot 4.3** — They stutter when parented to physics bodies. Use `CPUParticles2D` with `fract_delta = true` for high-speed 2D movement.
- **NEVER trigger `emitting = true` immediately after a `finished` signal** — Async GPU state delays can cause the restart to fail. Use the `restart()` method instead.
- **NEVER attempt recursion with sub-emitters** — A particle system cannot be its own sub-emitter; it will silently fail.
- **NEVER forget alpha in color gradients** — Particles that disappear instantly at the end of their lifetime look harsh; always add a gradient point at 1.0 with 0.0 alpha for a smooth exit.
- **NEVER use `EMISSION_SHAPE_POINT` for volumentric explosions** — Spawning all particles at a single point looks flat. Use a Sphere or Box shape for natural 3D spread.
- **NEVER forget to set `emitting = false` initially for one-shot VFX** — This prevents unwanted emission at the scene origin before you've had a chance to position the node via script.


## Choose Table (load only the matching script)

> **MANDATORY** for the chosen row. **Do NOT Load** unused particle scripts for a single effect.

| Goal | Prefer | Script |
|------|--------|--------|
| Burst / one-shot VFX (hit, muzzle, explode) | `GPUParticles*` + recycle | **MANDATORY** [particle_burst_emitter.gd](../scripts/particles_particle_burst_emitter.gd) + [smart_oneshot_recycler.gd](../scripts/particles_smart_oneshot_recycler.gd) |
| Trails behind movers | `local_coords = false` | **MANDATORY** [local_vs_global_coords.gd](../scripts/particles_local_vs_global_coords.gd) |
| Weather (rain/snow) heightfield | camera-snapped collision | **MANDATORY** [screenspace_weather_heightfield.gd](../scripts/particles_screenspace_weather_heightfield.gd) |
| Million-entity swarms | MultiMesh, not GPUParticles | **MANDATORY** [massive_swarm_multimesh.gd](../scripts/particles_massive_swarm_multimesh.gd) |
| Custom GPU motion / userdata | process material shader | [custom_particle_logic.gdshader](../scripts/particles_custom_particle_logic.gdshader), [dynamic_userdata_modulation.gd](../scripts/particles_dynamic_userdata_modulation.gd) |
| Impact sub-emitters | collision subparticle | [sub_emitter_impact.gdshader](../scripts/particles_sub_emitter_impact.gdshader) |
| Attractors without global cost | cull_mask isolation | [particle_attractor_opt.gd](../scripts/particles_particle_attractor_opt.gd) |
| Distant env VFX LOD | visibility_range | [particle_lod_manager.gd](../scripts/particles_particle_lod_manager.gd) |
| 2D physics-parented trails stutter | `CPUParticles2D` + fract_delta | **MANDATORY** [2d_physics_interpolation_fix.gd](../scripts/particles_2d_physics_interpolation_fix.gd) |
| Shader param orchestration | material helpers | [vfx_shader_manager.gd](../scripts/particles_vfx_shader_manager.gd) |

**GPUParticles vs CPUParticles vs MultiMesh**
- **GPUParticles*** — default for desktop/console VFX amount budgets.
- **CPUParticles2D** — only when 2D physics interpolation / smooth parenting is required (see NEVER).
- **MultiMesh** — when entity count leaves the particle domain (fish/insects/debris fields).

## Available Scripts

### [smart_oneshot_recycler.gd](../scripts/particles_smart_oneshot_recycler.gd)
Golden path for one-shot lifecycle: `finished` + `restart()` — never Timer-based free.

### [particle_burst_emitter.gd](../scripts/particles_particle_burst_emitter.gd)
One-shot bursts wired to the recycler.

### [local_vs_global_coords.gd](../scripts/particles_local_vs_global_coords.gd)
Aura vs trail coordinate space + teleport `restart()`.

### [screenspace_weather_heightfield.gd](../scripts/particles_screenspace_weather_heightfield.gd)
Global weather via camera-snapped heightfield collision.

### [massive_swarm_multimesh.gd](../scripts/particles_massive_swarm_multimesh.gd)
Million-entity path with `set_buffer_interpolated()`.

### [custom_particle_logic.gdshader](../scripts/particles_custom_particle_logic.gdshader)
Procedural GPU particle motion with CUSTOM/USERDATA.

### [sub_emitter_impact.gdshader](../scripts/particles_sub_emitter_impact.gdshader)
Collision-driven `emit_subparticle()` impacts.

### [particle_attractor_opt.gd](../scripts/particles_particle_attractor_opt.gd)
Attractor `cull_mask` isolation.

### [dynamic_userdata_modulation.gd](../scripts/particles_dynamic_userdata_modulation.gd)
Runtime USERDATA without breaking GPU batches.

### [particle_lod_manager.gd](../scripts/particles_particle_lod_manager.gd)
`visibility_range` hierarchy for env VFX.

### [2d_physics_interpolation_fix.gd](../scripts/particles_2d_physics_interpolation_fix.gd)
CPUParticles2D + `fract_delta` for physics-parented 2D trails.

### [vfx_shader_manager.gd](../scripts/particles_vfx_shader_manager.gd)
Custom shader integration helpers for particle materials.

## Expert Pointers

- One-shots: `emitting = false` at scene origin → place → `restart()` ([smart_oneshot_recycler.gd](../scripts/particles_smart_oneshot_recycler.gd)).
- Trails: `local_coords = false` or the trail sticks to the projectile.
- Do not invent explosion/smoke/sparkle material recipes here — Official Docs cover material UI; this skill owns lifecycle, coords, LOD, and swarm routing.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Particle systems (2D)](https://docs.godotengine.org/en/stable/tutorials/2d/particle_systems_2d.html) — GPUParticles2D/CPUParticles2D setup, amount/lifetime/one-shot, and when 2D trails need CPU particles for smooth motion.
- [ParticleProcessMaterial 2D](https://docs.godotengine.org/en/stable/tutorials/2d/particle_process_material_2d.html) — emission shapes, gravity/velocity curves, and color ramps that drive most 2D VFX without custom shaders.
- [Creating a 3D particle system](https://docs.godotengine.org/en/stable/tutorials/3d/particles/creating_a_3d_particle_system.html) — GPUParticles3D scene wiring, process material assignment, and first-emission checklist for 3D VFX.
- [Process material properties](https://docs.godotengine.org/en/stable/tutorials/3d/particles/process_material_properties.html) — ParticleProcessMaterial emission, forces, scale/color curves, and collision/sub-emitter modes used by expert patterns.
- [Particle properties](https://docs.godotengine.org/en/stable/tutorials/3d/particles/properties.html) — node-level amount, lifetime, explosiveness, local_coords, visibility AABB, preprocess, and restart/finished lifecycle.
- [Particle subemitters](https://docs.godotengine.org/en/stable/tutorials/3d/particles/subemitters.html) — chaining impact/debris systems and why a particle system cannot recurse as its own sub-emitter.
- [Particle collision](https://docs.godotengine.org/en/stable/tutorials/3d/particles/collision.html) — GPUParticlesCollision* shapes, rigid/hide modes, and GPU collision limits versus CPU-synced SFX.
- [Particle attractors](https://docs.godotengine.org/en/stable/tutorials/3d/particles/attractors.html) — attractor types plus cull_mask/layer isolation so global weather does not pay every attractor cost.
- [Particle trails](https://docs.godotengine.org/en/stable/tutorials/3d/particles/trails.html) — trail ribbons and why smoke/fire trails must use global space (`local_coords = false`).
- [Particle shader](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html) — `shader_type particles`, CUSTOM/USERDATA, COLLIDED/`emit_subparticle()`, and keep_data process loops.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — when millions of entities should bypass GPUParticles via MultiMesh + interpolated buffers.
- [Visibility ranges](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — GeometryInstance3D distance fade/hysteresis that stops distant environmental particle processing.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scenes, resources, and import basics before packing VFX Prefabs and GradientTexture1D materials.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed GPUParticles APIs, `finished` handlers, and safe `restart()`/await patterns used by pools and burst spawners.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — ShaderMaterial workflow and shading-language fundamentals required before `shader_type particles` process logic.

#### Complements
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — draw materials, transparency sorting, and next_pass stacks that render quads/meshes spawned by GPUParticles3D.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — emissive fire/sparks vs environment exposure; pair particle albedo with real lights when VFX must light the scene.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — impact/loop SFX while GPU emitters are active when per-particle collision audio is unavailable.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — amount budgets, visibility AABB, attractor masks, and MultiMesh cutovers when VFX dominate GPU time.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — camera-follow heightfields, visibility-range thresholds, and frustum-aware weather emitters.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `finished` and one-shot connection hygiene for pooled recyclers that must not leak ghost callbacks.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — physics-parented 2D trails where CPUParticles2D + interpolation replaces stuttering GPUParticles2D.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — hit sparks, blood/debris bursts, and muzzle FX spawned from damage resolution.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — cast/channel/impact VFX attached to ability lifecycle and targeting feedback.
- [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) — muzzle flash, tracers, explosions, and environmental smoke stacks built on these particle patterns.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — when VFX density/readability changes perceived difficulty or telegraph clarity, simulate juice budgets with combat outcomes.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
