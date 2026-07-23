# Aurelius Protocol: Particles NEVER List

- **NEVER use `amount_ratio` to optimize performance dynamically** — It does not save GPU memory or improve processing; the full `amount` is still allocated. Change the `amount` property directly instead.
- **NEVER use CPUParticles2D for performance-critical effects on Desktop** — Use GPUParticles unless targeting low-end mobile with no GPU support. However, use CPUParticles2D if you need Physics Interpolation for smooth trails on moving bodies in 2D.
- **NEVER set `preprocess` to extremely high values** — High values (e.g., 60s) will force the GPU to simulate thousands of frames in a single render tick, potentially causing an immediate GPU crash.
- **NEVER leave `visibility_aabb` unconfigured for large systems** — Incorrect AABBs cause frustum culling errors (particles popping out) and break LOD calculations. Generate AABBs using the editor toolbar.
- **NEVER enable turbulence on Mobile/Web without testing** — 3D noise evaluation per particle is extremely heavy. Disable via Feature Tags on lower-end platforms.
- **NEVER forget to `queue_free()` one-shot particles** — Use the `finished` signal instead of an arbitrary Timer for safe lifecycle management.
- **NEVER use `local_coords = true` for trails** — Smoke or fire left behind by a projectile MUST use global space (`local_coords = false`) or the trail will follow the projectile like a stiff stick.
- **NEVER expect GPUParticles2D to interpolate correctly in Godot 4.3** — They stutter when parented to physics bodies. Use `CPUParticles2D` with `fract_delta = true` for high-speed 2D movement.
- **NEVER trigger `emitting = true` immediately after a `finished` signal** — Async GPU state delays can cause the restart to fail. Use the `restart()` method instead.
- **NEVER attempt recursion with sub-emitters** — A particle system cannot be its own sub-emitter; it will silently fail.
- **NEVER forget alpha in color gradients** — Particles that disappear instantly at the end of their lifetime look harsh; always add a gradient point at 1.0 with 0.0 alpha for a smooth exit.
- **NEVER use `EMISSION_SHAPE_POINT` for volumentric explosions** — Spawning all particles at a single point looks flat. Use a Sphere or Box shape for natural 3D spread.
- **NEVER forget to set `emitting = false` initially for one-shot VFX** — This prevents unwanted emission at the scene origin before you've had a chance to position the node via script.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
- https://docs.godotengine.org/en/stable/classes/class_performance.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — remediation after profiler confirmation
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
