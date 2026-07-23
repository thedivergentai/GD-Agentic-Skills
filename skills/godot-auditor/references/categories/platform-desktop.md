# Aurelius Protocol: Platform Desktop NEVER List

- **NEVER hardcode resolution or fullscreen modes** — A 1920x1080 fullscreen on a 4K monitor is blurry. Always provide a settings menu with a resolution dropdown and a mode toggle.
- **NEVER ignore DPI scale factors** — Manually centering windows without `DisplayServer.screen_get_scale()` results in incorrect positioning on HiDPI displays.
- **NEVER skip a borderless window option** — Exclusive fullscreen can break multi-monitor focus. Offer `WINDOW_MODE_FULLSCREEN` (borderless).
- **NEVER use `keycode` for movement rebinds** — Use `physical_keycode` to ensure WASD works correctly across international keyboard layouts (AZERTY/Dvorak).
- **NEVER save settings or user data to `res://`** — Filesystem is read-only in exported releases. Always use `user://`.
- **NEVER skip `NOTIFICATION_WM_CLOSE_REQUEST`** — Failing to handle quit signals causes data loss. Intercept and flush and ConfigFile data before `get_tree().quit()`.
- **NEVER run utility tools at max framerate** — Enable `OS.low_processor_usage_mode` to prevent high GPU heat in static desktop apps.
- **NEVER call proprietary SDKs (Steam/Epic) directly** — Always wrap in `Engine.has_singleton()` to prevent crashes in non-store builds.
- **NEVER block the main thread with massive I/O** — Deserializing 100MB+ configs stalls the engine. Offload to `WorkerThreadPool`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
