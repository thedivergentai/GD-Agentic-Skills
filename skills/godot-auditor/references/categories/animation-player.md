# Aurelius Protocol: Animation Player NEVER List

- **NEVER forget RESET tracks** — Without a RESET track, animated properties don't restore to initial values when changing scenes. Create RESET animation with all default states [12].
- **NEVER use `Animation.CALL_MODE_CONTINUOUS` for function calls** — This calls the method EVERY frame during the keyframe. Use `CALL_MODE_DISCRETE` (calls once) to avoid logic spam [13, 77].
- **NEVER animate resource properties directly** — Animating `material.albedo_color` creates embedded resources that bloat file size. Store the material in a variable or use `instance uniform` instead [14].
- **NEVER use `animation_finished` for looping animations** — This signal doesn't fire for looped animations. Use `animation_looped` or check `current_animation` in `_process()`.
- **NEVER hardcode animation names as strings across large codebases** — Use constants or enums. Typos cause silent failures.
- **NEVER use `seek()` without `update=true` for same-frame logic** — If you need properties to update immediately (e.g., for physics checks), you MUST set the `update` parameter to `true`.
- **NEVER leave unnecessary AnimationPlayers `active`** — If an entity is off-screen and its animation is purely visual (no logic tracks), set `active = false` to save significant CPU/GPU processing [317].
- **NEVER change `AnimationLibrary` content while it is playing** — This causes immediate crashes or undefined transform states. Stop the player or wait for the `finished` signal before swapping libraries.
- **NEVER rely on `speed_scale` for long-term synchronization** — For multiplayer or rhythm games, use `seek()` with a global time reference to prevent frame-drift.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
