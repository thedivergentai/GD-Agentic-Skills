# Aurelius Protocol: Genre Idle Clicker NEVER List

- NEVER use standard floats for currency; strictly implement a **BigNumber** (Mantissa/Exponent) system (e.g., `1.5e300`) to prevent `INF` crashes at 1e308.
- NEVER use `Timer` nodes for revenue generation; strictly use a manual accumulator in `_process(delta)` to prevent drift during frame fluctuations.
- NEVER hardcode generator costs or growth; strictly use an exponential formula: `Cost = BasePrice * pow(GrowthFactor, OwnedCount)` (industry standard **1.15x**).
- NEVER evaluate exact float equality (`==`); strictly use `is_equal_approx()` or `>=` to prevent "stuck" progress due to precision loss.
- NEVER parse scientific notation strings with `to_int()`; strictly use `to_float()` or a dedicated BigNumber parser.
- NEVER update all UI labels every frame; strictly use **Signals** to update labels ONLY when values change, or throttle updates to 10 FPS.
- NEVER ignore **Low Processor Usage Mode** for mobile; strictly enable `OS.low_processor_usage_mode = true` to preserve battery life.
- NEVER instantiate/delete hundreds of text nodes per second; strictly use **Object Pooling** or `MultiMeshInstance` for click-feedback.
- NEVER update massive logs by modifying the `text` property; strictly use `append_text()` to prevent main thread blocking.
- NEVER ignore **Offline Progress**; strictly calculate `seconds_offline * total_revenue` using system UNIX timestamps (`Time.get_unix_time_from_system()`).
- NEVER make the "Prestige" reset feel like a loss; strictly provide a global multiplier that makes the next run **significantly** faster (2-5x).
- NEVER calculate offline time using `Time.get_ticks_msec()`; strictly use **Persistent UNIX timestamps** as ticks reset on app restart.
- NEVER use Node hierarchies for raw data; strictly use `RefCounted` or `Resource` objects for lightweight, serializable logic.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
