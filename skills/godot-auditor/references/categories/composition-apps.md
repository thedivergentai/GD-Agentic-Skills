# Aurelius Protocol: Composition Apps NEVER List

- **NEVER use get_parent() to fetch data** — Components must be blind. If they need data, it must be injected via `@export` or passed into a function call.
- **NEVER talk sideways** — `ComponentA` must never call functions on `ComponentB`. High-coupling makes refactoring impossible. Always signal up to the Orchestrator.
- **NEVER use brittle Node Paths** — `get_node("Child/Subchild/Node")` breaks when you move a single node. Use `@export` and the Inspector.
- **NEVER put business logic in the Orchestrator** — The Orchestrator should only have `_on_signal` methods that delegate to other components.
- **NEVER store global state in individual components** — Use a shared `Context` Resource or the Global Autoload for cross-scene state.
- **NEVER assume a component's parent is of a specific type** — If a `HealthComponent` requires its parent to be a `CharacterBody2D`, it fails the "Rock Test."
- **NEVER skip signal cleanup** — Connecting signals dynamically without disconnecting can lead to memory leaks or multiple execution bugs.
- **NEVER let Logic know about Visuals** — A `CombatComponent` should never call `AnimationPlayer.play()`. It emits `attack_performed`, and a `Syncer` or `Orchestrator` handles the visual response.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
