# Aurelius Protocol: Genre Romance NEVER List

- NEVER create "Vending Machine" romance; strictly incorporate variables like **NPC Mood**, **Timing**, and **Multi-Stat Thresholds** to ensure characters feel autonomous.
- NEVER use binary Affection (Love/Hate); strictly use a **Multi-Axial Model** (Attraction, Trust, Comfort) for believable psychological depth.
- NEVER focus on 100% opaque stats; strictly provide **Visible Indicators** (heart UI, blushing text, pulsing hearts) to help players make informed choices.
- NEVER use the "Same Date Order" trap; strictly implement a **Repetition Penalty** (~30%) for visiting the same location twice in a row.
- NEVER forget "Missable" Milestones; strictly ensure meaningful consequences (e.g., missing events due to poor scheduling) to add weight to the experience.
- NEVER ignore NPC Autonomy; strictly allow NPCs to have their own **Schedules** and the ability to **Reject** the player based on low trust or conflicting events.
- NEVER use `_process` for typewriter text; strictly use **Tweens on `visible_ratio`** for frame-independent, smooth reveals.
- NEVER parse massive narrative files on the main thread; strictly use **`ResourceLoader.load_threaded_request()`** to prevent transition stutters.
- NEVER use exact float math for affection checks; strictly use **`is_equal_approx()`** to avoid jitter-based logic failures.
- NEVER structure complex dialogue purely in code; strictly design dialogue trees as **Custom `Resource` classes** to decouple narrative data from logic.
- NEVER rely on the global OS clock for timed choices; strictly use **`SceneTreeTimer`** which respects `Engine.time_scale` and pause states.
- NEVER leave invisible controls with `MOUSE_FILTER_STOP`; strictly set to `IGNORE` or `PASS` on non-opaque layers to avoid blocking dialogue progression.
- NEVER hardcode dialogue strings; strictly map text to **Localization Keys** and retrieve via `tr()` for internationalization.
- NEVER use absolute pixel positioning for interfaces; strictly rely on **Anchoring & Containers** for responsive scaling across devices.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
