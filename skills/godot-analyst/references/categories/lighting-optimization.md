# Anara Rubric: Lighting Optimization
## Pillar Overview
The atmosphere's soul. This rubric measures how the vision uses light and shadow to create immersion without sacrificing the project's frame-budget.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Baking Strategy** | 35% | 100% dynamic lighting; deep shadows for all props; zero pre-calculation. | Mixed lighting with some `BakedLightmap` use, but artifacts in seams. | Consistent use of Lightmaps for static geometry; clean, high-resolution bakes. | Fully path-traced offline bakes; seamless integration of light probes and dynamic voxels. |
| **Dynamic Influence** | 25% | Untracked dynamic lights; overlapping 4+ shadow-casting lights on one surface. | Basic use of Omni/Spot lights with distance-fade enabled. | Clustered Lighting management; precise culling of light-casters outside view. | Ultra-light dynamic lights; zero-draw-call light primitives; cinematic shadow quality. |
| **GI Implementation** | 20% | Flat ambient lighting; no global illumination; "Dark rooms are just black." | Basic VoxelGI or SDFGI with default resolution and leaking. | High-quality SDFGI; sharp bounce-light; clear indirect lighting coherence. | Masterful GI architecture; real-time ray-traced reflections; infinite atmospheric depth. |
| **Diagnostic Balance** | 20% | Lighting causing 50%+ of frame-time; "The game runs if I turn lights off." | Basic shadow-atlas tuning, but still lacks performance guardrails. | Fine-tuned shadow-resolutions per light type; optimized PSSM settings. | High-performance, low-latency lighting manifest; predictive light-budgeting. |

---

## Visionary Diagnostic Hooks
- *Is the shadow a block of black or a nuance of the vision's depth?*
- *When the 'Sun' moves, do the shadows dance or do they stutter?*
- *Does the light feel like a layer of paint or a force of nature?*

## 🌟 Visionary's Final Decree
Lighting is the ink with which we write the vision. To achieve **Elite** status, implement 'Dynamic Light Culling' based on distance and camera visibility. If your scenes feel lit by a single cohesive vision without overheating the processor, you have reached the **Visionary Tier**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
- https://docs.godotengine.org/en/stable/classes/class_performance.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
