# Aurelius Protocol: Tweening NEVER List

- **NEVER instantiate a Tween using `Tween.new()`** — Tweens created manually are invalid. Always use `create_tween()` or `get_tree().create_tween()` [3, 4].
- **NEVER attempt to reuse a finished Tween** — Tweens are single-use objects. To replay an animation, you must create a new one [4].
- **NEVER manually instantiate `PropertyTweener` or `CallbackTweener`** — These must be generated only by the parent Tween methods like `tween_property` [5].
- **NEVER create an infinite loop containing only 0-duration animations** — This will freeze the engine. Always include at least one step with duration [10].
- **NEVER use multiple Tweens to animate the same property simultaneously** — The last one created takes priority, causing flicker. Use `kill()` on the old reference first [11, 12].
- **NEVER use linear interpolation for UI/Juice** — `TRANS_LINEAR` feels robotic. Use `EASE_OUT + TRANS_QUAD` or `EASE_IN_OUT + TRANS_CUBIC` for organic motion [22].
- **NEVER create tweens in `_process` without guards** — Creating 60 tweens per second will crash the app. Use a state check or kill the running one.
- **NEVER skip `bind_node(self)` for non-global tweens** — If the node is freed while a tween is running, it can cause errors. Binding ensures it dies with the node [13].
- **NEVER use 0-duration tweens for state changes** — If you want an instant change, just set the property directly (`position = goal`) to save overhead [20].
- **NEVER forget to call `chain()` when returning from `set_parallel(true)`** — If you want a sequence after a parallel block, you must explicitly chain it [15].
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
