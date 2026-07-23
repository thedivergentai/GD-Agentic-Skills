# Aurelius Protocol: Genre Visual Novel NEVER List

- NEVER create the "Illusion of Choice" exclusively; strictly provide **Immediate Dialogue Variations** or **Flag Changes** even if the plot converges later.
- NEVER skip mandatory QoL features; strictly implement **Auto-Play**, **Fast-Forward**, and **Backlog/History** for replayability.
- NEVER display "Walls of Text"; strictly limit dialogue boxes to **3-4 Lines** max to avoid intimidating the reader.
- NEVER hardcode dialogue text inside GDScripts; strictly store narrative scripts in **External Files** (JSON, CSV, or custom Resources) for iteration.
- NEVER ignore the **Rollback** mechanic; strictly maintain a history stack so players can undo miss-clicks or reread missed lines.
- NEVER use plain text for emotional beats; strictly use **RichTextLabel BBCode** (e.g., `[shake]`, `[wave]`) to add visual weight.
- NEVER parse massive narrative files on the main thread; strictly use **`ResourceLoader.load_threaded_request()`** to prevent transition stutters.
- NEVER use standard Strings for frequently accessed game flags; strictly use **`StringName`** (&"met_alice") for faster dictionary lookups.
- NEVER use `_process` for letter-by-letter animation; strictly use a **Tween on `visible_ratio`** for smooth, frame-independent reveals.
- NEVER neglect character **Z-ordering**; strictly ensure the active speaker is brought to the front (highest `z_index`) for visual clarity.
- NEVER use absolute pixel positioning for character sprites; strictly rely on **Anchors & Percent-based Offsets** for responsive scaling.
- NEVER allow text animations to continue when the player skips; strictly set **`visible_ratio` to 1.0** instantly on input.
- NEVER leave orphaned character sprites; strictly use **`queue_free()`** when actors exit the stage to prevent memory leaks.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
