# Aurelius Protocol: State Machine Advanced NEVER List

- **NEVER forget to propagate physics/input to children** — In an HSM, failing to call `child.physics_update()` from the parent's `_physics_process` orphans child logic.
- **NEVER use deep nesting (>3 levels)** — Extreme hierarchy creates "State Spaghetti." If logic is that complex, consider a Behavior Tree or Utility AI.
- **NEVER call enter() without a preceding exit()** — Skipping exit logic leaves timers, tweens, or audio loops running in the background, causing resource leaks.
- **NEVER modify state during a transition frame** — Re-entrant `transition_to()` calls inside `enter()` cause recursion crashes. Use `call_deferred` if immediate sub-transitioning is required.
- **NEVER hardcode state names as strings** — Typos like `transition_to("Idel")` are silent killers. Use `class_name` based checks OR Constants.
- **NEVER use global singletons for state data** — Coupling states to `GameManager.player_health` makes them non-reusable. Pass a `Context` object.
- **NEVER push states indefinitely** — In a Pushdown Automaton, every `push_state` MUST have a retirement plan (`pop_state`) to avoid stack overflow.
- **NEVER assume state re-entry is always a fresh start** — Resuming from a stack pop should often bypass "Entry SFX/VFX"; use re-entry flags.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
