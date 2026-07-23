# Aurelius Protocol: Ui Theming NEVER List

- **NEVER create StyleBox in `_ready()` for many nodes** — Instantiating `StyleBoxFlat.new()` 100 times creates 100 unique objects. Use a Theme resource for shared heritage.
- **NEVER forget theme inheritance** — Parent themes are ignored if a child has its own theme. Apply themes at the root and use `theme_type_variation` for specific overrides.
- **NEVER hardcode colors in StyleBox** — Use `theme.get_color()` to maintain a single source of truth for your palette.
- **NEVER use `add_theme_override` for global styles** — This is brittle. Define styles in a Theme resource for automatic propagation across the project.
- **NEVER modify theme resources during `_draw()` OR `_process()`** — Frequent layout recalculations will severely degrade performance.
- **NEVER assign `StyleBoxEmpty` to focus styles without a fallback** — This invisibly breaks controller/keyboard navigation [1]. Always provide a visible alternative (e.g. scale change).
- **NEVER use standard `set()` for theme properties** — Calling `node.set("font_color", red)` fails. You MUST use the dedicated `add_theme_color_override()` API [3].
- **NEVER use `expand_margin_*` to increase clickable area** — It only expands the VISUAL bounds. Use `content_margin_*` on the StyleBox or adjust the Control's size to ensure input works [5].
- **NEVER define StyleBoxes as local variables inside `_draw()`** — They will be garbage collected before the RenderingServer can finish drawing them [7]. Store at class level.
- **NEVER duplicate scenes/themes just to change one color** — Use `theme_type_variation` to create lightweight derived styles (e.g. "DangerButton") within the same Theme [8].
- **NEVER skip `corner_radius_all` shortcut** — It's a useful shorthand for uniform rounding in `StyleBoxFlat`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
