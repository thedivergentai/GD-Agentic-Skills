---
name: godot-platform-desktop
description: "Expert blueprint for desktop platforms (Windows/Linux/macOS) covering keyboard/mouse controls, settings menus, window management (fullscreen, resolution), keybind remapping, and Steam integration. Use when targeting PC platforms or implementing desktop-specific features. Keywords desktop, Windows, Linux, macOS, settings, keybinds, ConfigFile, DisplayServer, Steam, fullscreen."
---

# Platform: Desktop

Settings flexibility, window management, and kb/mouse precision define desktop gaming.

## NEVER Do (Expert Desktop Rules)

### Window & Display
- **NEVER hardcode resolution or fullscreen modes** — Always provide a settings menu with resolution + mode toggle.
- **NEVER ignore DPI scale factors** — Use `DisplayServer.screen_get_scale()` / usable rects.
- **NEVER skip a borderless window option** — Offer `WINDOW_MODE_FULLSCREEN` (borderless) for multi-monitor focus.

### Input & Persistence
- **NEVER use `keycode` for movement rebinds** — Use `physical_keycode` for AZERTY/Dvorak.
- **NEVER save settings or user data to `res://`** — Always `user://`.
- **NEVER skip `NOTIFICATION_WM_CLOSE_REQUEST`** — Flush ConfigFile before `get_tree().quit()`.

### Performance & Integration
- **NEVER run utility tools at max framerate** — Enable `OS.low_processor_usage_mode` for static tools.
- **NEVER call proprietary SDKs (Steam/Epic) directly** — Wrap with `Engine.has_singleton()` guards.
- **NEVER block the main thread with massive I/O** — Offload to `WorkerThreadPool`.

---

## Godot 4.7: Desktop

- **HDR output** on Windows, macOS, and Linux (Wayland) — enable in Rendering → Viewport settings.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern. Do not paste inline settings/rebind/Steam tutorials — the scripts are the golden path.

### [desktop_window_manager.gd](scripts/desktop_window_manager.gd)
Expert DPI-aware multi-monitor window positioning using `DisplayServer`.

### [desktop_settings_persistent.gd](scripts/desktop_settings_persistent.gd)
Production settings persistence using `ConfigFile` for persistent INI data.

### [physical_input_rebinder.gd](scripts/physical_input_rebinder.gd)
Expert positional rebind system using `physical_keycode` for AZERTY/Dvorak.

### [platform_sdk_wrapper.gd](scripts/platform_sdk_wrapper.gd)
Safe PC SDK singleton wrapper (Steamworks/Epic) with crash guards.

### [native_dialog_helper.gd](scripts/native_dialog_helper.gd)
Expert native OS file dialogs and system alerts logic.

### [secondary_window_spawner.gd](scripts/secondary_window_spawner.gd)
True multi-window management for secondary Viewports/Windows.

### [graceful_shutdown_handler.gd](scripts/graceful_shutdown_handler.gd)
Safe close-request interceptor for data flushing and exit guards.

### [low_processor_eco_mode.gd](scripts/low_processor_eco_mode.gd)
Eco mode optimization for desktop tools and launchers.

### [desktop_performance_monitor.gd](scripts/desktop_performance_monitor.gd)
OS-level hardware detection for dynamic graphics presets.

### [native_shell_executor.gd](scripts/native_shell_executor.gd)
Expert native shell command execution and output capture.

---

## Desktop Golden Path (MANDATORY scripts)

0. **Resolution / stretch** — use the mini-tree below, then **MANDATORY** [desktop_window_manager.gd](scripts/desktop_window_manager.gd).
1. **Window / DPI** — **MANDATORY** [desktop_window_manager.gd](scripts/desktop_window_manager.gd): multi-monitor position, scale, mode restore.
2. **ConfigFile settings** — **MANDATORY** [desktop_settings_persistent.gd](scripts/desktop_settings_persistent.gd): graphics/audio/window under `user://`.
3. **Physical rebinds** — **MANDATORY** [physical_input_rebinder.gd](scripts/physical_input_rebinder.gd): `physical_keycode` only.
4. **Close flush** — **MANDATORY** [graceful_shutdown_handler.gd](scripts/graceful_shutdown_handler.gd): `NOTIFICATION_WM_CLOSE_REQUEST` → save → quit.
5. **Store SDK** — **MANDATORY** [platform_sdk_wrapper.gd](scripts/platform_sdk_wrapper.gd) before any store call: `if Engine.has_singleton("Steam")` → Steam API; `elif Engine.has_singleton("EOS")` → Epic; else no-op stub. Gate features with export feature tags (`steam` / `epic`).

### Resolution / stretch mini-tree

| Player need | Window mode | Script hook |
| :--- | :--- | :--- |
| Fullscreen game, alt-tab friendly | `WINDOW_MODE_FULLSCREEN` (borderless) | [desktop_window_manager.gd](scripts/desktop_window_manager.gd) |
| Exclusive fullscreen (lowest latency) | `WINDOW_MODE_EXCLUSIVE_FULLSCREEN` | Same — persist choice in ConfigFile |
| Windowed / multi-monitor drag | `WINDOW_MODE_WINDOWED` + usable rect / DPI scale | Same + [desktop_settings_persistent.gd](scripts/desktop_settings_persistent.gd) |

**CI smoke:** headless `--path . --quit-after 1` with settings round-trip write/read under `user://` before merge (pairs with [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md)).

## Expert Callouts (keep short — not full tutorials)

### 1. Alt-Tab stuck-input guard
On `NOTIFICATION_APPLICATION_FOCUS_OUT`, pause and `Input.action_release` held movement actions so OS-swallowed key-ups do not strand velocity.

### 2. Desktop launcher note
Lightweight launcher projects may `OS.create_process` the main pack after writing `user://settings.cfg`; pair with [low_processor_eco_mode.gd](scripts/low_processor_eco_mode.gd) while idle in menus.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html) — Window modes, `screen_get_scale` / usable rects, and native file-dialog features behind multi-monitor and HiDPI desktop settings.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch modes, aspect, and content scale so resolution dropdowns stay sharp across 1080p–4K displays.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — `NOTIFICATION_WM_CLOSE_REQUEST` / `set_auto_accept_quit(false)` so Alt+F4 and window-close flush ConfigFile before exit.
- [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html) — INI-style persistence for graphics, audio, and window state under `user://`.
- [File paths in Godot projects](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — Why settings and saves must use `user://` (exported `res://` is read-only).
- [InputEventKey](https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html) — `physical_keycode` vs `keycode` so WASD rebinds survive AZERTY/Dvorak layouts.
- [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) — Runtime `action_erase_events` / `action_add_event` for desktop rebind UIs.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Focus-loss stuck-key pitfalls (`NOTIFICATION_APPLICATION_FOCUS_OUT`) when Alt-Tabbing on PC.
- [Window](https://docs.godotengine.org/en/stable/classes/class_window.html) — Secondary/tool windows and mode/size/position restore for true multi-window desktop apps.
- [OS](https://docs.godotengine.org/en/stable/classes/class_os.html) — `low_processor_usage_mode`, `create_process` / `execute`, and `alert` for launchers and native shell hooks.
- [Creating applications](https://docs.godotengine.org/en/stable/tutorials/ui/creating_applications.html) — Desktop-style app chrome, dialogs, and quit UX beyond game-only loops.
- [Engine](https://docs.godotengine.org/en/stable/classes/class_engine.html) — `has_singleton` / `get_singleton` guards so Steam/Epic GDExtensions never crash standalone builds.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Display stretch, feature tags (`windows`/`linux`/`macos`), and project defaults every desktop settings menu depends on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — InputEvent buffering and action design before wiring `physical_keycode` rebind UIs.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Settings screens, dropdowns, and remapper rows that stay layout-correct across resolutions.

#### Complements
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Game-save ownership that pairs with ConfigFile settings and graceful close-request flushes.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton homes for window managers, SDK wrappers, and shutdown handlers.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Bus volume persistence that desktop graphics/audio options menus usually expose together.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Touch/safe-area remaps when the same project keeps desktop kb/mouse paths after a mobile port.
- [godot-adapt-mobile-to-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-mobile-to-desktop/SKILL.md) — Bringing touch-first titles up to window modes, keybinds, and multi-monitor expectations.
- [godot-composition-apps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md) — Tooling/launcher composition patterns that lean on eco mode, native dialogs, and secondary windows.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and quality presets after OS-level hardware detection suggests Ultra vs Balanced.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Windows/Linux/macOS export presets, icons, and store packaging once desktop settings and SDK wrappers are stable.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Sibling platform skill for dual-target projects that must not assume desktop quit/window APIs on phones.
- [godot-platform-web](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md) — Browser constraints (no multi-window / limited shell) when shipping the same settings stack to HTML5.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this platform skill beside sibling domains.
