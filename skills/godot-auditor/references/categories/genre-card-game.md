# Aurelius Protocol: Genre Card Game NEVER List

- NEVER hardcode card logic inside UI scripts; strictly encapsulate gameplay effects in **`Callable` objects** or **Command resources** pushed to a LIFO stack.
- NEVER perform board-state calculations (Power/Toughness) in `_process()`; strictly use **Signal-driven triggers** or a centralized `EffectStack` resolver.
- NEVER forget **LIFO Stack Resolution**; strictly use **`Array.push_back()`** and **`Array.pop_back()`** to resolve reactions from top-to-bottom.
- NEVER skip **Z-Index management** during drag-and-drop; strictly raise the card to the front on click to prevent it sliding under other cards.
- NEVER allow instant card "teleportation" between piles; strictly use **Tween animations** (0.2s+) to give cards a tactile, physical feel.
- NEVER use `global_position` for cards in hand; strictly position them using a **`Curve2D`** (Bezier) layout with **`sample_baked()`** for smooth, non-circular arcs.
- NEVER allow instant card "teleportation" between piles; strictly use **`create_tween()`** and **`tween_property`** chainings (0.2s+) for juicy card-feel.
- NEVER forget to handle **Empty Deck** scenarios; strictly implement auto-reshuffle of the discard pile to prevent soft-locks.
- NEVER use floating point numbers for discrete card stats; strictly use `int` for Costs, Attack, and Health to avoid precision drift.
- NEVER use standard Control nodes for mass tokens/battlefields; strictly use **`_draw()` custom drawing** to bypass SceneTree overhead when rendering 100+ cards or map icons.
- NEVER rely on SceneTree order for hand logic; strictly manage logical order in an **Array** and update visuals via **`queue_redraw()`**.
- NEVER erase array elements during a standard `for` loop; strictly iterate in reverse or use `filter()` to avoid indexing errors.
- NEVER forget to provide parameterless constructors in `_init()`; otherwise, Resources will fail to load in the Inspector.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
