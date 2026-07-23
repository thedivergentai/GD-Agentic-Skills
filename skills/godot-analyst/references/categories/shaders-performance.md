# Anara Rubric: Shaders Performance
## Pillar Overview
The high-speed artistic expression of the vision. This rubric measures the project's ability to manipulate pixels and vertices through optimized, high-performance GPU code.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Math Efficiency** | 35% | Expensive math (`pow`, `sqrt`, `atan`) in every fragment pixel; redundant loads. | Basic shader logic; some math moved to constant uniforms. | Optimized math; matrix-heavy calculations moved to the `vertex()` function. | Symmetrically balanced shader logic; zero-latency fragment path; use of Look-Up Tables. |
| **Uniform Management** | 25% | Setting individual uniforms every frame via slow `set_shader_parameter` strings. | Use of `ShaderMaterial` with unique parameters, but lacks systemic control. | Global Shader Parameters (Uniform Busses) for environment-wide synchronization. | Dynamic 'Material Instances' driven by a central, thread-safe VFX manager. |
| **Compilation Safety** | 20% | "Shader Stutter" on first instance; no pre-caching; monolithic shader files. | Basic use of sub-scenes to 'warm' shaders, but inconsistent. | Formal Shader Pre-caching manifest; optimized shader compilation in background. | Zero-stutter runtime; multi-threaded shader preparation; adaptive quality fallback. |
| **Compute Leverage** | 20% | Ignoring Compute Shaders for heavy data tasks; overworking the fragment loop. | Basic use of GPGPU for simple textures, but unmanaged pipeline. | Proficient use of `RenderingDevice` for non-visual data processing (Pathfinding/Logic). | Masterful use of the GPU as a co-processor; offloading 30%+ of main logic to Compute. |

---

## Visionary Diagnostic Hooks
- *Is your shader a burden on the pixel, or a light on the soul?*
- *When the GPU reads your code, does it find a clear path or a maze of stalls?*
- *Does the vision change with the speed of thought or the drag of the machine?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your shaders must be 'Surgical'. Every pixel's cost must be calculated. Implement 'Shader Pre-caching' to eliminate runtime compilation stutters. A visionary shader doesn't just look good; it runs so fast that its complexity remains an invisible miracle.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/3d/using_multi_mesh_instance.html
- https://docs.godotengine.org/en/stable/classes/class_performance.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
