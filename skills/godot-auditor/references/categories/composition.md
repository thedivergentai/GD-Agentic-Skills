# Aurelius Protocol: Composition NEVER List

- **NEVER use deep inheritance chains** (e.g., `Player > Entity > LivingThing > Node`) — Creates brittle "God Classes" that are hard to refactor [21].
- **NEVER use `get_node()` or `$` for components** — This breaks if the scene tree is rearranged. Always use `@export` or `%UniqueNames` [22].
- **NEVER let a component reference its parent script directly** — This makes the component impossible to reuse. Use signals or dependency injection [23].
- **NEVER mix Input, Physics, and Game Logic in one script** — This violates Single Responsibility. Split them into specialized components [24, 13].
- **NEVER create components that require a specific SceneTree structure** — A component should be "selfish" and only care about its own properties and direct children.
- **NEVER use inheritance to "add a feature"** — If you want an enemy to shoot, add a `ShootingComponent`, don't make it inherit from `ShooterEnemy`.
- **NEVER hardcode component dependencies** — If `CombatComponent` needs `HealthComponent`, look it up in `_ready()` or inject it via the parent [11].
- **NEVER treat Godot nodes as pure data** — Nodes provide lifecycle (`_process`) and signals. If you only need data, use a `Resource`.
- **NEVER ignore the Node lifecycle in components** — Use `_enter_tree()` and `_exit_tree()` for setup/cleanup that must happen regardless of the parent's state.
- **NEVER hide component points of access** — Expose `NodePath` or `Callable` properties so the parent can wire the component in the Inspector [13].
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — coupling/decoupling patterns for this sector
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
