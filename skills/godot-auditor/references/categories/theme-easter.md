# Aurelius Protocol: Theme Easter NEVER List

- **NEVER use sharp edges or high-contrast blacks** — Easter aesthetics favor rounded corners (`corner_radius > 12`) and soft pastel tones.
- **NEVER use standard linear scaling for pops** — Linear scaling feels 'robotic.' Always use `TRANS_ELASTIC` or `TRANS_QUART` for organic eggs.
- **NEVER use billboarding for Easter particles** — In close-up UI or VR, billboard sparkles look flat. Use mesh-based particles or axial rotation.
- **NEVER modify the original .mesh or .tres resource** — Swapping materials on a shared Resource changes it for EVERY instance in the game. Always use `surface_override` or `duplicate()`.
- **NEVER run date-checks in _process** — Checking the system calendar every frame is wasteful. Run `Time.get_date_dict_from_system()` once on `_ready` or event trigger.
- **NEVER ignore the 'No-Seasonal' toggle** — Some players hate seasonal overrides. Always provide a 'Disable Seasonal Themes' option in settings.
- **NEVER have 'Static' collectibles** — If a player finds an egg, it MUST react (wobble, sparkle, or pop). Dead items feel like bugs.
- **NEVER skip the camera feedback** — A collect event without a subtle camera shake or lens kick feels 'hollow.'
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
