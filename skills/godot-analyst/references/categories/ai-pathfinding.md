# Anara Rubric: AI Pathfinding
## Pillar Overview
The intent of navigation. This rubric assesses how the project handles agent movement, path-calculations, and world-awareness through Godot's navigation server.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Path Fidelity** | 35% | Units walk through walls; uncalculated paths; jagged, unoptimized movement. | Basic A* or NavigationAgent usage; path is found but lacks 'Smoothing' or 'Cornering'. | Robust Navigation Link integration; multi-agent navigation; smooth path-following (Curves). | Anticipatory navigation; agents avoid each other dynamically; 100% terrain-aware. |
| **Performance (Calc)** | 25% | Calculating paths for 100+ units on the main thread every frame; massive stutter. | Basic use of `NavigationServer2D/3D` but lacks path-caching or batching. | Async path-requests; optimized NavMesh partitioning; high-speed agent updates. | Zero-latency navigation; hierarchical pathfinding (HPA*); compute-baking of nav-zones. |
| **Agent Steering** | 20% | Agents overlap or 'vibrate' when colliding; no separation or avoidances. | Basic `avoidance_enabled` use in NavigationAgent; functional but simple. | Context-steering algorithms; smooth avoidance curves; group-coherent movement. | Fluid swarm intelligence; zero-collision navigation; organic steering-behaviors. |
| **World Awareness** | 20% | NavMesh is static; cannot handle moving obstacles (doors/bridges) without re-baking. | Use of `NavigationObstacle`, but results are clumsy or cause agent clipping. | Real-time NavMesh updates; dynamic region-toggling; agents adapt to world changes. | Smart-environment navigation; agents 'understand' the world's topology; predictive moves. |

---

## Visionary Diagnostic Hooks
- *Does the agent know 'Where' it is, or just 'What' it hit?*
- *When the door closes, does the vision find a new path or a wall?*
- *Is your path a line or a flow?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, pathfinding must be 'Proactive'. The agent shouldn't wait to hit an obstacle; it should perceive the world and adjust its steering in advance. Use **NavigationLayers** to ensure agents stay on the right path for their soul. Slop is an agent that gets stuck; Vision is an agent that finds its way home.
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
