# Aurelius Protocol: Rpg Stats NEVER List

- **NEVER use integers for percentages** — `critical_chance = 50`? Integer division (e.g., in formulas) causes truncation. Always use `float` (0.0 to 1.0 or 0.0 to 100.0) [20].
- **NEVER modify current_health without emitting signals** — UI elements like health bars will desync if you don't broadcast changes to the system [21].
- **NEVER rely solely on additive modifiers** — +10 strength is huge at level 1 but negligible at level 50. Use multiplicative or hybrid scaling for balance [22].
- **NEVER add modifiers without a unique ID or Key** — Without a reference (e.g., "potion_buff"), you cannot remove specific effects without clearing the entire stack [23].
- **NEVER use exponential XP formulas without a growth cap** — Uncapped `pow()` scaling quickly leads to unreachable levels or integer overflows [24].
- **NEVER forget to clamp derived values** — Negative vitality from a debuff could result in negative max HP, crashing your health logic. Use `maxi(val, 1)` [25].
- **NEVER perform heavy stat recalculations in `_process()`** — Only recalculate when a modifier is added/removed or base stats change. Use the "Reactive" pattern.
- **NEVER hardcode stat names in logic** — Use StringNames or an Enum for attributes to prevent typos and facilitate refactoring (e.g., `get_attribute("strength")`).
- **NEVER store temporary "Runtime Only" buffs in a permanent Save Resource** — Clear short-duration modifiers before serializing player progress to disk.
- **NEVER calculate damage directly in the Character script** — Centralize combat math in a `DamageFormula` class to ensure consistency across Players and NPCs.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
