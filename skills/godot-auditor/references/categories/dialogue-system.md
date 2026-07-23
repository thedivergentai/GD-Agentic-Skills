# Aurelius Protocol: Dialogue System NEVER List

- **NEVER hardcode dialogue text directly in your GDScript files** — This makes translation impossible. Store text in Resources or external JSON/CSV files [12].
- **NEVER display choices that the player hasn't met the criteria for** — Hidden choices should stay hidden unless they are "grayed out" intentionally to show a missed path [13].
- **NEVER use loose strings for node transitions without validation** — Typos in `next_node_id` will crash the dialogue mid-convo. Use `assert()` or a central ID registry [14].
- **NEVER force a typewriter effect without a "Skip" option** — Forcing players to read at a fixed speed leads to frustration. Always allow clicking to finish the line [15].
- **NEVER store the current dialogue state inside a UI node** — If the UI is closed or the scene changes, the player loses their place. Use an AutoLoad `DialogueManager` [16].
- **NEVER use `get_node()` to find dialogue UI from the NPC script** — Use signals like `DialogueManager.start_dialogue(res)` to maintain a decoupled architecture.
- **NEVER use complex regex for simple text tags** — Godot's `RichTextLabel` supports BBCode tags natively. Use `[b]`, `[i]`, and `[url]` for formatting.
- **NEVER perform save/load operations inside a dialogue node** — Conversation nodes should be pure data. Delegate persistence to a dedicated `SaveSystem`.
- **NEVER block the main thread for text reveal timing** — Never use `OS.delay_msec()`. Use `create_timer()` or `Tween` to maintain smooth 60fps performance.
- **NEVER hardcode portrait paths** — Assign textures directly to the `DialogueNode` resource in the inspector or use a central `PortraitDatabase`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
