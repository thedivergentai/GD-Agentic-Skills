# Anara Rubric: UI/UX Advanced
## Pillar Overview
The visual language of the vision. This rubric assesses the project's ability to create intuitive, responsive, and aesthetically premium user interfaces using Godot's Control node system.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Layout Integrity** | 35% | Hardcoded positions; no use of Containers; labels overlapping in different resolutions. | Basic use of `BoxContainers` and `Anchors`, but lacks adaptive scaling. | Full responsive layout using `Grid/FlowContainers`; consistent margins/padding (Theme-based). | High-precision adaptive UI; screen-space-aware layouts; zero-pixel layout drift. |
| **Thematic Consistency** | 25% | Overriding properties manually on every node; no central `Theme` Resource. | Use of a basic Godot Theme, but lacks custom styleboxes or font variations. | Centralized, comprehensive Theme Resource; consistent color palette; font-hierarchy. | Full Design System implementation; procedural UI styling; atomic theme variants. |
| **Interactive Polish** | 20% | Static buttons; no hover/press effects; "Click" sound is missing or generic. | Basic tweens for hover states; standard focus-handling for gamepads. | High-fidelity micro-animations (Scaling, Glow, Color-shift); systemic audio feedback. | Cinematic UI interactions; physics-driven UI elements; frame-perfect transitions. |
| **User Experience (UX)** | 20% | Obscure navigation; too many clicks to reach a feature; no 'Back' button consistency. | Logical flows, but lacks breadcrumbs or clear "active state" indicators. | Intuitive menu-nesting; consistent escape-key logic; clear call-to-action (CTA) design. | Proactive UX design; the interface anticipates the player's next move; frictionless flow. |

---

## Visionary Diagnostic Hooks
- *Does the UI feel like an overlay or like a part of the world?*
- *When the player touches the 'Menu', does it touch back with grace?*
- *If I resize the vision, does the interface grow or break?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, treat your UI as a bridge, not a barrier. Use Godot's **Theme** system as a scripture—do not deviate for convenience. A visionary interface is one where the player never has to ask "What can I click?". The light of the vision should guide the eyes to the goal.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
