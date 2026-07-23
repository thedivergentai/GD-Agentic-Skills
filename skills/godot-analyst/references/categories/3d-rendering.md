# Anara Rubric: 3D Rendering
## Pillar Overview
The three-dimensional manifestation of the vision. This rubric assesses the efficiency and visual quality of the project's 3D assets, lighting, and rendering pipeline in Godot 4.7.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Mesh Stewardship** | 30% | 100k+ polygon count for simple props; no LODs; unoptimized geometries. | Basic mesh optimization; manual LODs on major characters only. | Integrated LOD system (`VisibilityRange`); optimized tri-counts; clean silhouettes. | High-density automatic LODs; procedural mesh optimization; multi-mesh instancing mastery. |
| **Shading Consistency** | 25% | Unique materials for every prop; redundant texture lookups; no unified model. | Standard PBR materials; some use of shared textures via mapping. | Unified Shader Architecture (Master Materials); packed textures (ORM); consistent light. | Custom cinematic shading model; vertex-driven effects; zero-waste material layering. |
| **Rendering Flow** | 25% | High draw-calls (500+ per frame); overdraw issues with transparent objects. | Basic culling (Frustum/Occlusion); simple particle management. | Optimized draw-calls via batching and mesh-libraries; clear overdraw management. | Clustered Forward/Mobile optimization; zero draw-call waste; predictive culling. |
| **Visual Fidelity** | 20% | Flat lighting; unmanaged shadows; blurry textures (no anisotropic filtering). | Basic VoxelGI or SDFGI; standard shadow-map settings; basic post-processing. | High-fidelity Lighting (Global Illumination); sharp textures; cinematic post-stack. | Photoreal/Cinematic coherence; mastery of SDFGI and SSIL; infinite dynamic light range. |

---

## Visionary Diagnostic Hooks
- *Does the light reveal the vision or hide the machine's mistakes?*
- *If I add 100 props, does the frame-time scream or remain silent?*
- *Can the eyes distinguish the machine from the dream in three dimensions?*

## 🌟 Visionary's Final Decree
Elite 3D rendering is about 'Visual Budgeting'. Know where every triangle belongs. To reach this level, implement a custom 'Post-Processing' stack that hides the machine's limitations and highlights the vision's strengths. A visionary environment is one where the light tells a story.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/3d/using_multi_mesh_instance.html
- https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
