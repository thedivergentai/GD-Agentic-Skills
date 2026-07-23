# Anara Rubric: VFX Shaders
## Pillar Overview
The light-bending spirit of the vision. This rubric assesses the project's use of shader-driven visual effects to create impact, atmosphere, and cinematic flair.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Visual Complexity** | 35% | Basic 'Color-swap' shaders; simple noise patterns; static textures only. | Functional特效 (Dissolves, Outlines), but lacks 'Depth' or 'Energy' flows. | Advanced multi-layered effects (Distortion, Fresnel, SDF-masks); procedural noise. | Cinematic visual manifestations; vertex-manipulation mastery; hyper-dynamic VFX. |
| **Engine Integration** | 25% | Shaders require manual variable-updates in `_process()` every frame to 'Animate'. | Using the shader `TIME` variable, but lacks synchronization with game-events. | Driven by uniforms and signal-busses; shaders react to world logic (e.g. hit-flashes). | Seamless logic-to-GPU flow; compute-driven VFX; reactive visual ecosystems. |
| **Performance (Fill)** | 20% | Overdraw of 5+ fullscreen shaders; massive fragment-latency; low resolution. | Basic optimization via shader-complexity toggles, but still heavy on mobile/low-end. | Optimized fragment-pipelines (Step over Sin); screen-space-aware complexity. | Zero-latency effects; high-performance compute-VFX; minimal GPU cost per pixel. |
| **Artistic Coherence** | 20% | VFX look 'Stock' or out of place; different styles for different effects. | Consistent palette, but lacks a 'Signature' visual language or style. | Unified VFX style; consistent shader-libraries; shared noise-manifests. | Transcendent visual identity; the shaders define the vision's artistic soul. |

---

## Visionary Diagnostic Hooks
- *Is the 'Flame' a texture or a force?*
- *When the 'Spell' casts, does the GPU feel the magic?*
- *Does the 'Blur' reveal the depth or hide the machine?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your VFX must be 'Generative'. They should not rely on pre-baked textures alone. Use **VisualShader** or code to create beauty from nothing but math. If an effect doesn't react to the world's light, it is **Slop**. A visionary effect is a bridge between art and math.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
