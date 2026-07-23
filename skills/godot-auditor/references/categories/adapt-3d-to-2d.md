# Aurelius Protocol: Adapt 3D To 2D NEVER List

- **NEVER remove Z-axis without gameplay compensation** — Blindly flattening 3D to 2D removes spatial strategy. Add other depth mechanics (layers, jump height variations).
- **NEVER keep 3D collision shapes** — Use simpler 2D shapes (CapsuleShape2D, RectangleShape2D). 3D shapes don't convert automatically.
- **NEVER use orthographic Camera3D as "2D mode"** — Use actual Camera2D for proper 2D rendering pipeline and performance.
- **NEVER assume automatic performance gain** — Poorly optimized 2D (too many draw calls, large sprite sheets) can be slower than optimized 3D.
- **NEVER forget to adjust gravity** — 3D gravity is Vector3(0, -9.8, 0). 2D gravity is float (980 pixels/s²). Scale appropriately.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
