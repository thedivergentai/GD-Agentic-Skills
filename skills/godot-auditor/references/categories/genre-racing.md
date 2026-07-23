# Aurelius Protocol: Genre Racing NEVER List

- NEVER use a rigid camera attachment; strictly use a **Smooth Follow** pattern with `lerp()` to prevent motion sickness.
- NEVER prioritize realism over fun; strictly increase **Gravity Scale** (2x-3x) and keep friction high for responsive arcade feel.
- NEVER use `VehicleBody3D` default settings for karts; strictly rewrite suspension using Raycasts or custom spring/damper models.
- NEVER apply steering torque directly to mass; strictly use a steering curve factored by lateral velocity.
- NEVER calculate suspension without a damper model; strictly include damping to prevent eternal oscillation (bouncing).
- NEVER ignore the **Center of Mass** property; strictly offset it downward to ensure stability during high-speed turns.
- NEVER multiply engine force by `delta`; it is an integrated force in the physics solver.
- NEVER rely on `is_action_pressed()` for manual gear shifting; strictly use `is_action_just_pressed()` for single-tap accuracy.
- NEVER use static AI speeds; strictly use **Rubber-Banding** to keep races competitive based on player distance.
- NEVER run AI pathfinding across the entire track every frame; strictly use a "Look-Ahead" point on a spline/path.
- NEVER ignore racing **Checkpoints**; strictly enforce sequential `Area3D` validation to prevent track shortcuts.
- NEVER use standard `Area3D` for slipstreaming without a **Dot Product** check to ensure the player is directly behind.
- NEVER skip "Sense of Speed" effects; strictly implement dynamic **FOV scaling**, motion blur, and high-speed camera shake.
- NEVER update minimap transforms for static elements in `_process()`; strictly update dynamic racers only.
- NEVER serialize ghost cars as mass transform lists; strictly store positions/quaternions at fixed intervals.
- NEVER use constant pitch for engine sounds; strictly map RPM or engine load to `pitch_scale`.
- NEVER spawn particles for skid marks every frame; strictly use **Trail3D** or procedural strips for low-cost persistence.
- NEVER use standard Strings for surface detection; strictly use `StringName` (e.g., `&"asphalt"`).
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
