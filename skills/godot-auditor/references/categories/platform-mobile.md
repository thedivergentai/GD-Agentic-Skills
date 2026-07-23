# Aurelius Protocol: Platform Mobile NEVER List

- **NEVER use mouse events for touch interaction** — Relying on `InputEventMouseButton` on mobile is unreliable. Always use `InputEventScreenTouch` and `InputEventScreenDrag` for high-fidelity multi-touch support.
- **NEVER ignore display safe areas (notches/cutouts)** — UI placed behind a camera notch is unusable. Query `DisplayServer.get_display_safe_area()` and offset critical UI accordingly.
- **NEVER assume fixed orientation** — Locking a landscape game without handling the `size_changed` signal leads to broken layouts on foldable devices or tablet orientation shifts.
- **NEVER maintain high framerate when backgrounded** — Keeping an app at 60 FPS in the background drains battery. Use `NOTIFICATION_APPLICATION_PAUSED` to drop `Engine.max_fps` to 1.
- **NEVER use the Forward+ renderer for mobile** — Most mobile GPUs are not optimized for Forward+. Use the dedicated **Mobile** or **Compatibility** renderers for optimal fill-rate.
- **NEVER leave 'ETC2/ASTC' texture compression disabled** — Uncompressed desktop textures will crash mobile devices due to VRAM exhaustion.
- **NEVER assume Android permissions are automatically granted** — You MUST explicitly call `OS.request_permission()` and verify with `OS.get_granted_permissions()`.
- **NEVER call handheld vibration without permission** — On Android, vibration calls are ignored unless the `VIBRATE` permission is enabled in the export preset.
- **NEVER block the main thread for I/O** — Large file saves on mobile can trigger ANR (Application Not Responding) errors. Use background threads.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
