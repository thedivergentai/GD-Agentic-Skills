# Anara Rubric: NavMesh Steering
## Pillar Overview
The organic movement of the vision. This rubric assesses the project's implementation of steering behaviors and obstacle avoidance on navigation meshes.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Behavioral Coherence** | 35% | Units snapping to new vectors immediately; jerky, robotic movement. | Basic linear steering; functional, but lacks 'Weight' or 'Anticipation'. | Balanced steering forces (Seek, Flee, Arrive); organic acceleration curves. | Complex behavioral orchestration; flocking (Boids); context-aware velocity. |
| **Avoidance Precision** | 25% | Units passing through each other; jitter when multiple units meet. | Reciprocal Velocity Obstacles (RVO) use; functional, but some clipping. | High-fidelity avoidance; smooth navigation around dynamic obstacles; no clipping. | Predictive avoidance; agents 'negotiate' space sub-frame; zero-collision swarm. |
| **NavMesh Fidelity** | 20% | NavMesh is inaccurate or broken at seams; agents 'fall through' or get stuck. | Functional NavMesh, but lacks clear 'Baking' strategy for changing levels. | Optimized NavMesh generation; clear boundary management; multi-layer support. | Dynamic NavMesh warping; agents move through transformed spaces with grace. |
| **Engine Performance** | 20% | Calculating steering for 50+ units in GDScript every frame; high main-thread lag. | Strategic use of built-in `NavigationAgent`, but lacks server-side offloading. | Steering calculations moved to low-level Servers; efficient high-load updates. | 100% server-side steering; GPU-accelerated navigation (Compute); zero main-thread impact. |

---

## Visionary Diagnostic Hooks
- *Does the agent move like a soul or like a vector?*
- *Complexity: Does the steering hide the machine's math or reveal its flaws?*
- *When the crowd gathers, is it a mess or a dance?*

## 🌟 Visionary's Final Decree
A visionary agent moves with 'Intent'. To reach **Elite** status, ensuring that your steering behaviors use **Context Maps** to decide direction. Movement is the first sign of a living vision—do not let the math be cold.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
