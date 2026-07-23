# Aurelius Protocol: Ui Rich Text NEVER List

- **NEVER use complex BBCode in tight loops** — Parsing a 10,000 character string with 500 tags every frame will tank performance. Cache your formatted strings.
- **NEVER forget to register Custom Effects** — Writing the script isn't enough. You MUST add the instance to `RichTextLabel.custom_effects` list via Inspector or `install_effect()`.
- **NEVER use absolute pixel sizes in [img]** — `[img width=128]` fails on higher resolutions. Use `rich_text_image_scaler.gd` to sync with line height.
- **NEVER use [url] without visual feedback** — If the text doesn't change color on hover or the cursor doesn't change, players won't know it's clickable. Use `rich_text_hover_reactive.gd`.
- **NEVER perform heavy logic inside `meta_clicked`** — This signal is on the Main Thread. Use it to emit a command and handle processing asynchronously if needed.
- **NEVER use `visible_ratio` for pausing typewriter** — `visible_ratio` is unreliable for per-character logic. Use `visible_characters` and explicit character indexing (`rich_text_typewriter_controller.gd`).
- **NEVER allow unfiltered user input in Chat Labels** — A user could type `[img]huge_image_path[/img]` or `[color=transparent]` to break your UI. ALWAYS use `rich_text_bbcode_sanitizer.gd`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
