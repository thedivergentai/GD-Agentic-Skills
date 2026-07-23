---
name: godot-adapt-mobile-to-desktop
description: "Expert patterns for scaling mobile games to desktop including mouse/keyboard controls, increased resolution and graphical fidelity, expanded UI layouts, settings menus, window management, and platform-specific features. Use when creating desktop ports or cross-platform releases. Trigger keywords: mouse_controls, keyboard_shortcuts, resolution_scaling, graphics_settings, fullscreen_toggle, window_modes, Steam_integration, desktop_optimization."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Adapt: Mobile to Desktop

Expert guidance for scaling mobile games to desktop platforms.

## NEVER Do

- **NEVER keep touch-only controls** — Add mouse/keyboard alternatives. Touch controls on desktop feel awkward and limit precision.
- **NEVER lock to mobile resolution** — Desktop can handle 1920x1080+ and higher frame rates. Upscale UI, increase render distance.
- **NEVER hide graphics settings** — Desktop players expect quality options (resolution, VSync, shadows, anti-aliasing).
- **NEVER use mobile-sized UI** — Touch targets (44pt) are too large for mouse. Reduce button/text size by 30-50%.
- **NEVER forget window management** — Players expect fullscreen, borderless, maximize, and multi-monitor support.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [desktop_input_adapter.gd](../scripts/adapt_mobile_to_desktop_desktop_input_adapter.gd)
**MANDATORY first read for input remap** — Bridges mobile actions to keyboard/mouse without rewriting gameplay. Emits `mouse_look_bridge_requested` when FPS capture is needed — pair with mouse_capture_look.

### [hover_bridge.gd](../scripts/adapt_mobile_to_desktop_hover_bridge.gd)
**MANDATORY when UI needs hover** — Restores desktop hover/focus affordances mobile never had. Prefer this over ad-hoc `mouse_entered` dumps.

### [mouse_capture_look.gd](../scripts/adapt_mobile_to_desktop_mouse_capture_look.gd)
Captured look via `InputEventMouseMotion.relative` — use for FPS/orbit when adapter alone is not enough.

### [dynamic_window_manager.gd](../scripts/adapt_mobile_to_desktop_dynamic_window_manager.gd)
**MANDATORY** — Windowed / exclusive fullscreen / borderless via DisplayServer.

### [keybinding_remapper.gd](../scripts/adapt_mobile_to_desktop_keybinding_remapper.gd)
Runtime InputMap remap + ConfigFile persistence.

### [cursor_state_manager.gd](../scripts/adapt_mobile_to_desktop_cursor_state_manager.gd)
Hardware cursor show/hide/combat vs menu states.

### [uncapped_framerate.gd](../scripts/adapt_mobile_to_desktop_uncapped_framerate.gd)
VSync / `Engine.max_fps` unlock for 144Hz+.

### [resolution_dropdown.gd](../scripts/adapt_mobile_to_desktop_resolution_dropdown.gd)
Native resolution OptionButton from `DisplayServer.screen_get_size`.

### [desktop_ui_scaler.gd](../scripts/adapt_mobile_to_desktop_desktop_ui_scaler.gd)
**MANDATORY** — Shrink thumb-sized mobile Controls for mouse density.

### [scroll_wheel_zoom.gd](../scripts/adapt_mobile_to_desktop_scroll_wheel_zoom.gd)
Mouse-wheel zoom replacing pinch.

### [quit_confirmation.gd](../scripts/adapt_mobile_to_desktop_quit_confirmation.gd)
**MANDATORY** — `set_auto_accept_quit(false)` + save prompt on WM close.

### [multi_monitor_handling.gd](../scripts/adapt_mobile_to_desktop_multi_monitor_handling.gd)
Launch/place window on the screen under the cursor.

---

## Decision Tree — Input Script Picks

| Need | Use |
|------|-----|
| Map touch actions → WASD/mouse without rewriting movers | **desktop_input_adapter** |
| Button/Control hover styles & tooltips | **hover_bridge** |
| Captured mouselook (FPS/3P orbit) | **mouse_capture_look** — **MANDATORY** when aim/Look requires captured relative motion; adapter `get_aim_vector()` alone is top-down only |
| Rebindable keys | **keybinding_remapper** |
| Pinch → wheel zoom | **scroll_wheel_zoom** |

When `desktop_input_adapter` emits `mouse_look_bridge_requested`, attach or enable [mouse_capture_look.gd](../scripts/adapt_mobile_to_desktop_mouse_capture_look.gd) on the player/camera rig — do not stop after InputMap injection.

## Port Procedure (ordered)

1. **MANDATORY** desktop_input_adapter (+ hover_bridge for UI) so every touch action has a precision equivalent.
2. desktop_ui_scaler + expanded layouts (hotbar/chat/minimap) — godot-ui-containers for structure.
3. dynamic_window_manager + multi_monitor_handling + quit_confirmation.
4. resolution_dropdown + uncapped_framerate + graphics quality ladder (persist ConfigFile).
5. Deeper OS integration → godot-platform-desktop.

## Platform Services Decision Tree (Steam / Discord)

| Goal | Decision |
|------|----------|
| Ship on Steam with cloud/achievements | Add **GDExtension** bridge (e.g. GodotSteam); keep init behind `OS.has_feature("steam")` / editor-safe stubs. Do **not** paste fake `Steam.*` tutorials into gameplay scripts. |
| Discord Rich Presence only | Prefer a thin GDExtension/plugin; update presence from an Autoload on scene change — never block `_ready` on network. |
| No store integration this milestone | **Cut** — omit Steam/Discord code paths entirely; document as future GDExtension spike. |

## Deep Recipes

> **MANDATORY** when porting beyond the ordered procedure: read [desktop-port-deep.md](adapt-mobile-to-desktop-desktop-port-deep.md). **Do NOT Load** it for a first-pass keyboard/mouse remap.

## Testing (before ship)

> **MANDATORY** before declaring the port complete: run [desktop-port-testing-checklist.md](adapt-mobile-to-desktop-desktop-port-testing-checklist.md). Do not inline a partial checklist — use the reference file.

## Expert Techniques (short)

- Optional lightweight launcher via `OS.create_process` + `user://settings.cfg` before main pack.
- Short FPS benchmark → write `user://override.cfg` quality suggestions.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event pipeline for replacing `InputEventScreenTouch`/`ScreenDrag` with mouse motion, buttons, and keyboard actions on desktop.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Viewport vs canvas transforms so mouse aim and hover hit the same UI/game space as former touch targets.
- [Custom mouse cursor](https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html) — Hardware cursor shapes and hide/show rules for combat vs menus (`Input.set_custom_mouse_cursor`).
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Practical WASD, mouse-look, and action patterns that map onto mobile virtual-joystick / button actions.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — `NOTIFICATION_WM_CLOSE_REQUEST` / `set_auto_accept_quit(false)` so the OS close button can prompt save instead of silent exit.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch mode, aspect, and content scale when leaving fixed mobile base resolutions for 1080p–4K and ultrawide.
- [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html) — Window modes, VSync, screen count/size/position, and refresh-rate queries behind fullscreen and multi-monitor ports.
- [Window](https://docs.godotengine.org/en/stable/classes/class_window.html) — Per-window size, position, and mode APIs used with borderless / exclusive fullscreen toggles.
- [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) — Runtime remapping of actions to keycodes so PC players can rebind what mobile hard-coded as touch zones.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — Anchor/offset contracts when shrinking thumb-sized controls for mouse density without breaking layout.
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — Box/Grid/Margin layout rules for expanded desktop HUDs (hotbars, chat, minimap) vs compact mobile stacks.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — `pc` / `mobile` / OS tags for branching input, UI scale, and graphics quality without separate projects.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Shared InputEvent buffering, action maps, and device detection before injecting WASD/mouse equivalents for mobile actions.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Anchors, containers, and minimum sizes so desktop UI shrink/expand passes keep layout correct across resolutions.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Inventory the mobile lifecycle, touch, and safe-area assumptions you are replacing before desktop window/input paths take over.

#### Complements
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Deeper Windows/macOS/Linux DisplayServer and OS integration once the mobile→desktop control and settings remap is in place.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Mouse-look, orbit, and scroll-wheel zoom rigs that replace swipe/pinch camera controls.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and quality ladders when unlocking FPS, MSAA, shadows, and draw distance for desktop GPUs.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Durable save ownership hooked to window-close confirmation and settings `ConfigFile` persistence.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Theme type variations and hover styles that mobile never showed but desktop players expect on buttons/menus.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Display stretch, renderer, and feature-tag project defaults that every desktop port branch depends on.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton homes for window managers, input adapters, and graphics settings that must outlive scene changes.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Packaging and CI export presets for Windows/macOS/Linux after input/UI/window gates pass on desktop.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Inverse lattice when the same codebase must keep or regain touch-first paths after a desktop-first pass.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Re-tune difficulty when mouse precision and higher FPS invalidate mobile touch timing and aim curves.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this adapt skill beside sibling domains.
