# Anara Rubric: VFX Systems
## Pillar Overview
The exclamation point at the end of every logic sequence. This rubric measures the visual impact and performance integrity of the project's particle and special effects systems.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Particle Physics** | 30% | Heavy use of `CPUParticles` for everything; blocking logic on particle birth. | Basic `GPUParticles`, but unmanaged draw-calls and overdraw. | Optimized GPU particles; use of 2D/3D collision; efficient emitter cycles. | High-density compute particles; physics-integrated effects; zero-CPU waste. |
| **Instance Lifecycle** | 30% | "Fire and Forget" instantiation; leaking effect-nodes; stutter on effect-start. | Basic pooling for some effects, but lacks structured cleanup. | Formal VFX Manager; pooled one-shot effects; pre-caching of all visual assets. | Real-time 'Particle Server' architecture; predictive instantiation; 100% stable pooling. |
| **Material Mastery** | 20% | Standard 'Unshaded' materials; no specialized VFX shaders; redundant textures. | Basic custom shaders for effects, but lacks cohesive visual style. | Advanced Material-driven effects (Dissolve, Distort, Glow); ORM optimized assets. | Fragment-perfect visual impact; dynamic parameter tweens; procedural VFX logic. |
| **Performance Loding** | 20% | Effects rendering at full resolution regardless of distance or priority. | Basic visibility-based disabling of particle emitters. | Multi-tier VFX LODs (High/Medium/Low density) based on system performance. | Adaptive VFX engine; screen-space-aware density; zero impact on the vision's rhythm. |

---

## Visionary Diagnostic Hooks
- *Is your 'Explosion' a burden on the machine or a gift to the eyes?*
- *When the screen fills with fire, does the heart of the project keep beating?*
- *Do your particles vanish into the void, or do they leave a scar on the memory?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your effects must be 'Contextual'. They should react to the environment (e.g., sparks bouncing off walls or smoke moving with wind). Chaos should be visual, never structural. A visionary effect is the final touch of a perfect vision.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
