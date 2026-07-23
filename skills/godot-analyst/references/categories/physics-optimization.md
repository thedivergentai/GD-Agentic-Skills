# Anara Rubric: Physics Optimization
## Pillar Overview
The solid ground of the vision. This rubric assesses how the project handles collisions, velocity, and world-interaction without causing the machine to stumble.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Collision Layering** | 35% | All objects on Layer 1; heavy use of 'Area monitoring' without filtering. | Basic use of 2-3 layers; manual bitmasks, but still some redundant checks. | Strict Layer/Mask architecture; zero-cost collision filtering; optimized collision shapes. | High-precision spatial mapping; dynamic layer-swapping; zero wasted CPU colliders. |
| **Integrator Precision** | 25% | Physics logic in `_process()` instead of `_physics_process()`; jittery movement. | Use of `_physics_process`, but erratic velocity manipulation; no interpolation. | Fixed-timestamp logic; frame-perfect movement; using Godot's built-in physics interpolation. | Deterministic physics simulation; custom velocity integration; sub-frame precision. |
| **Server Offloading** | 20% | Direct node-to-node physics queries every frame; slow `intersect_ray` calls. | Basic usage of `PhysicsDirectSpaceState3D` for raycasts, but unmanaged. | Batching physics queries through a central Manager; optimized raycast lifecycle. | Moving heavy physics tasks (e.g. 1000+ units) to the low-level PhysicsServer directly. |
| **Body Stewardship** | 20% | Creating/Destroying `RigidBody` nodes high-frequency; leaking collision shapes. | Basic pooling for simple physics objects, but lacks rigid-body state-resetting. | Full state-safe Body Pooling; unmanaged bodies are disabled when outside the vision. | GPU-accelerated collision detection; ultra-high-density agent physics (10k+ bodies). |

---

## Visionary Diagnostic Hooks
- *Does the floor hold the weight of the vision, or is it a suggestion to the engine?*
- *When two souls collide, does the machine scream or resolve the union with grace?*
- *Is your 'Gravity' a constant law or a variable mess?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, you must think in 'Layers'. No object should ever ask "Who am I hitting?". The layers should answer that before the question is born. Slop is a physics engine that calculates everything; Vision is an engine that calculates only what the eyes can perceive.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
