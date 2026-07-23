---
name: godot-adapt-desktop-to-mobile
description: "Expert patterns for porting desktop games to mobile including touch control schemes (virtual joystick, gesture detection), UI scaling for small screens, performance optimization for mobile GPUs, battery life management, and platform-specific features. Use when creating mobile ports or cross-platform mobile builds. Trigger keywords: TouchScreenButton, virtual_joystick, gesture_detector, InputEventScreenTouch, InputEventScreenDrag, mobile_optimization, battery_saving, adaptive_performance, MOBILE_ENABLED."
---

# Adapt: Desktop to Mobile

Expert guidance for porting desktop games to mobile platforms.

## NEVER Do

- **NEVER use mouse position directly** — Touch has no "hover" state. Replace mouse_motion with screen_drag and check InputEventScreenTouch.pressed.
- **NEVER keep small UI elements** — Apple HIG requires 44pt minimum touch targets. Android Material: 48dp. Scale up buttons 2-3x.
- **NEVER forget finger occlusion** — User's finger blocks 50-100px radius. Position critical info ABOVE touch controls, not below.
- **NEVER run at full performance when backgrounded** — Mobile OSs kill apps that drain battery in background. Pause physics, reduce FPS to 1-5 when app loses focus.
- **NEVER use desktop-only features** — Mouse hover, right-click, keyboard shortcuts, scroll wheel don't exist on mobile. Provide touch alternatives.

---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

## Godot 4.7: Desktop→Mobile

- Use built-in **virtual joystick** instead of third-party touch plugins where possible.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern. Do not paste joystick/gesture/UI tutorials inline.

### [dynamic_joystick_spawner.gd](../scripts/adapt_desktop_to_mobile_dynamic_joystick_spawner.gd)
**MANDATORY for move sticks** — Joystick appears where the user touches the left half (prefer over fixed-position recipes).

### [virtual_joystick.gd](../scripts/adapt_desktop_to_mobile_virtual_joystick.gd)
Fixed-base stick Control — use when UI art requires a static well; otherwise prefer dynamic_joystick_spawner.

### [gesture_combo_system.gd](../scripts/adapt_desktop_to_mobile_gesture_combo_system.gd)
**MANDATORY for swipe/pinch** — Duration/distance/multi-touch ratio → signals.

### [mobile_ui_adapter.gd](../scripts/adapt_desktop_to_mobile_mobile_ui_adapter.gd)
**MANDATORY for Control remaps** — Scales/reanchors desktop HUD for thumb reach + density.

### [resolution_scaler.gd](../scripts/adapt_desktop_to_mobile_resolution_scaler.gd)
Adaptive `scaling_3d_scale` to hold 60FPS while keeping 2D UI sharp.

### [battery_saver_mode.gd](../scripts/adapt_desktop_to_mobile_battery_saver_mode.gd)
**MANDATORY** — `NOTIFICATION_APPLICATION_PAUSED` → `Engine.max_fps = 1` + pause physics.

### [ui_safe_area_margins.gd](../scripts/adapt_desktop_to_mobile_ui_safe_area_margins.gd)
`DisplayServer.get_display_safe_area()` padding for notches / hole-punch.

### [touch_camera_pan_zoom.gd](../scripts/adapt_desktop_to_mobile_touch_camera_pan_zoom.gd)
1-finger pan + 2-finger pinch Camera2D.

### [haptic_feedback_manager.gd](../scripts/adapt_desktop_to_mobile_haptic_feedback_manager.gd)
`Input.vibrate_handheld` + iOS plugin hook pattern.

### [mobile_shader_fallback.gd](../scripts/adapt_desktop_to_mobile_mobile_shader_fallback.gd)
Strip SSS/clearcoat/heavy shading on weak mobile renderers.

### [on_screen_keyboard_handler.gd](../scripts/adapt_desktop_to_mobile_on_screen_keyboard_handler.gd)
Virtual keyboard occlusion → tween UI up. **Use for LineEdit/TextEdit focus** — not a substitute for HUD scaling.

### [mobile_ui_adapter.gd](../scripts/adapt_desktop_to_mobile_mobile_ui_adapter.gd) vs on_screen_keyboard_handler

| Need | Script |
|------|--------|
| Scale/reanchor HUD, spawn virtual sticks, thumb-reach density | **mobile_ui_adapter** |
| OS virtual keyboard covers focused text field | **on_screen_keyboard_handler** (often both: adapter for layout, OSK handler for text fields) |

### [offline_save_sync.gd](../scripts/adapt_desktop_to_mobile_offline_save_sync.gd)
**MANDATORY** — Persist on App Pause (WM_CLOSE is unreliable on mobile kill).

---

## Touch Control Schemes

### Decision Matrix

| Genre | Recommended Control | Script |
|-------|-------------------|--------|
| Platformer | Virtual joystick (left) + jump button (right) | dynamic_joystick_spawner / virtual_joystick |
| Top-down shooter | Dual-stick (move left, aim right) | dynamic_joystick_spawner ×2 |
| Turn-based | Direct tap on units/tiles | gesture_combo_system (tap) |
| Puzzle | Tap, swipe, pinch | gesture_combo_system |
| Card game | Drag-and-drop | mobile_ui_adapter + drag Controls |
| Racing | Tilt or tap left/right | platform-mobile / Input sensors |

### Port Procedure (ordered)

1. **MANDATORY** [mobile-port-checklist.md](adapt-desktop-to-mobile-mobile-port-checklist.md) — confirm pre-port inventory and gate rows before remapping controls.
2. Replace hover/right-click/scroll with touch equivalents (decision matrix).
3. **MANDATORY** safe-area + mobile_ui_adapter for 44–48dp targets; keep critical HUD above fingers.
4. Hook battery_saver_mode + offline_save_sync on pause/resume.
5. Enable resolution_scaler + mobile_shader_fallback until device FPS is stable.
6. Deep Android/iOS IAP/permissions → godot-platform-mobile (Do NOT Load full platform skill until control/UI/perf gates pass).

## Edge Cases (checklist)

- Multi-touch index conflicts on dual sticks
- OSK covering LineEdit (on_screen_keyboard_handler)
- Background kill without save (offline_save_sync)
- Notch clipping (ui_safe_area_margins)

## Deep Recipes

> **MANDATORY** when porting beyond the decision matrix: read [mobile-port-deep.md](adapt-desktop-to-mobile-mobile-port-deep.md). **Do NOT Load** it for a first-pass control remap.

## Expert Techniques (short)

- Capture store screenshots via `await RenderingServer.frame_post_draw` + viewport image.
- Debug overlay: `OS.get_memory_info()` — do not spam heavy allocs while monitoring.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event pipeline and why `InputEventScreenTouch` / `InputEventScreenDrag` replace hover/mouse-motion assumptions on mobile.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Viewport vs canvas transforms so touch positions land on the same UI/game space as desktop mouse tests.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Practical multi-touch and drag patterns that map to virtual joysticks, swipes, and pinch gestures.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch modes, aspect, and content scale so phone/tablet layouts keep touch targets readable.
- [Resolution scaling](https://docs.godotengine.org/en/stable/tutorials/3d/resolution_scaling.html) — `scaling_3d_scale` / FSR tradeoffs used by adaptive quality when mobile GPUs miss frame budget.
- [Introduction to the 3 rendering methods](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html) — Why ports should prefer **Mobile** or **Compatibility** over Forward+ for fill-rate and feature set.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — `NOTIFICATION_APPLICATION_PAUSED` / resume lifecycle that mobile OSes use instead of reliable window-close saves.
- [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html) — `get_display_safe_area()`, virtual keyboard APIs, and screen metrics behind notches and OSK occlusion.
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — Margin/Box/Grid container contracts for safe-area padding and large touch targets.
- [TouchScreenButton](https://docs.godotengine.org/en/stable/classes/class_touchscreenbutton.html) — Built-in on-screen buttons that emit Input actions without custom hit-testing.
- [Exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) — Permissions, APK/AAB, and device testing gates after the control/UI port is ready.
- [Exporting for iOS](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html) — Xcode export, capabilities, and App Store constraints that catch desktop leftovers late.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Shared InputEvent buffering, deadzones, and multi-touch gesture foundations before building virtual joysticks or swipe combos.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Anchors, containers, and minimum sizes so 44–48px touch targets and safe-area margins stay layout-correct.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Feature tags (`mobile`/`android`/`ios`), display stretch, and renderer defaults that every port branch depends on.

#### Complements
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Deeper Android/iOS platform APIs (permissions, IAP, thermal) once the desktop→touch control remap is in place.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and CPU/GPU cuts when adaptive `scaling_3d_scale` and material fallbacks are not enough.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Durable save ownership that hooks pause/resume instead of desktop-only quit notifications.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera2D/3D follow and zoom contracts used by one-finger pan + two-finger pinch controllers.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Cheaper CanvasItem/Spatial shader paths when stripping desktop-only visual features for mobile GPUs.
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — StandardMaterial3D feature flags (SSS, clearcoat) that `mobile_shader_fallback` disables on weak renderers.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Smooth UI lifts when the OS virtual keyboard covers LineEdits/TextEdits.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton homes for haptic feedback, battery saver, and offline save sync managers.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Packaging, signing, and CI export presets after touch/UI/perf gates pass on devices.
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Keep desktop mouse/keyboard paths working when the same project remains dual-input after the mobile adapt.
- [godot-genre-puzzle](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md) — Tap/swipe/pinch control schemes that consume the gesture and UI scaling patterns from this skill.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this adapt skill beside sibling domains.
