# Aurelius Protocol: Camera Systems NEVER List

- **NEVER use `global_position = target.global_position` every frame** — Instant position matching causes jittery movement. Use `lerp()` or `position_smoothing_enabled = true` [12].
- **NEVER use `offset` for permanent camera positioning** — `offset` is for shake, sway, or temporary recoil effects only. Use `position` for permanent framing to avoid logic conflicts [14].
- **NEVER forget `limit_smoothed = true` for `Camera2D`** — Hard boundaries cause jarring visual stops. Smoothing against limits ensures a professional feel [13].
- **NEVER enable multiple `Camera2D` nodes in the same viewport simultaneously** — Only the last enabled camera takes precedence. Explicitly disable inactive cameras [15].
- **NEVER use `SpringArm3D` without a collision mask** — It will clip through terrain and walls. Set it to the world/environment layer [16].
- **NEVER implement screen shake by randomizing `position` directly** — This overwrites follow-logic. Use `offset` or a dedicated Trauma/Noise system to Layer shake over the follow-position [27, 28].
- **NEVER parent the Camera directly to a high-speed physics body** — Physics stutter or parent rotation will cause motion sickness. Use `RemoteTransform2D/3D` with rotation sync disabled for a stable view [30].
- **NEVER use `look_at()` in 3D without a fallback for the 'Up' vector** — If the target is directly above/below, the camera will flip wildly. Use guards or `Quaternion` math for vertical tracking.
- **NEVER rely on `SubViewport` defaults for Mini-maps** — Viewports are expensive; explicitly set `render_target_update_mode` to `UPDATE_WHEN_VISIBLE` or a fixed lower framerate to save GPU [156].
- **NEVER use linear interpolation for Zoom** — It feels 'robotic'. Use exponential lerp or a `Tween` with `TRANS_CUBIC` for a more natural tactical feel.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
