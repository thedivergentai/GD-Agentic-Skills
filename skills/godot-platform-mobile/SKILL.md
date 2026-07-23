---
name: godot-platform-mobile
description: "Expert blueprint for mobile platforms (Android/iOS) covering touch controls, virtual joysticks, responsive UI, safe areas (notches), battery optimization, and app store guidelines. Use when targeting mobile releases or implementing touch input. Keywords mobile, Android, iOS, touch, InputEventScreenTouch, virtual joystick, safe area, battery, app store, orientation."
---

# Platform: Mobile

Touch-first input, safe area handling, and battery optimization define mobile development.

## NEVER Do (Expert Mobile Rules)

### Input & Display
- **NEVER use mouse events for touch interaction** — Relying on `InputEventMouseButton` on mobile is unreliable. Always use `InputEventScreenTouch` and `InputEventScreenDrag` for high-fidelity multi-touch support.
- **NEVER ignore display safe areas (notches/cutouts)** — UI placed behind a camera notch is unusable. Query `DisplayServer.get_display_safe_area()` and offset critical UI accordingly.
- **NEVER assume fixed orientation** — Locking a landscape game without handling the `size_changed` signal leads to broken layouts on foldable devices or tablet orientation shifts.

### Battery & Performance
- **NEVER maintain high framerate when backgrounded** — Keeping an app at 60 FPS in the background drains battery. Use `NOTIFICATION_APPLICATION_PAUSED` to drop `Engine.max_fps` to 1.
- **NEVER use the Forward+ renderer for mobile** — Most mobile GPUs are not optimized for Forward+. Use the dedicated **Mobile** or **Compatibility** renderers for optimal fill-rate.
- **NEVER leave 'ETC2/ASTC' texture compression disabled** — Uncompressed desktop textures will crash mobile devices due to VRAM exhaustion.

### Permissions & OS Integration
- **NEVER assume Android permissions are automatically granted** — You MUST explicitly call `OS.request_permission()` and verify with `OS.get_granted_permissions()`.
- **NEVER call handheld vibration without permission** — On Android, vibration calls are ignored unless the `VIBRATE` permission is enabled in the export preset.
- **NEVER block the main thread for I/O** — Large file saves on mobile can trigger ANR (Application Not Responding) errors. Use background threads.

---

## Godot 4.7: Mobile

- **Built-in virtual joystick** — native touch joystick without plugins for mobile builds.
- **HDR output** on iOS and supported Android devices — test tonemapping on HDR panels.

## Available Scripts

> **MANDATORY**: Pick the golden-path branch, then load only the matching scripts.

### Golden path
1. Run the **decision tree** below (control × orientation × renderer).
2. Touch / stick → `mobile_gesture_recognizer.gd` (+ input skill for action maps). Built-in virtual joystick when sufficient.
3. Layout / notches → `adaptive_safe_area_inset.gd` + `orientation_layout_adaptor.gd`.
4. Lifecycle / thermal → `thermal_throttle_monitor.gd` (pause FPS + heat).
5. Permissions / share / IAP → `android_runtime_permissions.gd`, `native_share_invoker.gd`, `mobile_iap_flow_boilerplate.gd` as needed.
6. VRAM / compression → `mobile_vram_optimizer.gd`.

### Script index
### [mobile_gesture_recognizer.gd](scripts/mobile_gesture_recognizer.gd)
Expert multi-touch logic for pinch-to-zoom and two-finger rotation.

### [adaptive_safe_area_inset.gd](scripts/adaptive_safe_area_inset.gd)
Dynamic safe-area (notch) handling using `DisplayServer` insets.

### [thermal_throttle_monitor.gd](scripts/thermal_throttle_monitor.gd)
Battery and heat management via `NOTIFICATION_APPLICATION_PAUSED`.

### [mobile_iap_flow_boilerplate.gd](scripts/mobile_iap_flow_boilerplate.gd)
Unified boilerplate for Android/iOS In-App Purchases (IAP).

### [haptic_pattern_generator.gd](scripts/haptic_pattern_generator.gd)
Advanced vibration patterns for mobile haptic feedback.

### [android_runtime_permissions.gd](scripts/android_runtime_permissions.gd)
Expert Android permission requesting and verification logic.

### [mobile_sensor_fusion.gd](scripts/mobile_sensor_fusion.gd)
Stable motion controls using Accelerometer and Gravity fusion.

### [orientation_layout_adaptor.gd](scripts/orientation_layout_adaptor.gd)
Adaptive UI swapping for Landscape/Portrait transitions.

### [mobile_vram_optimizer.gd](scripts/mobile_vram_optimizer.gd)
VRAM monitoring and texture compression enforcement rules.

### [native_share_invoker.gd](scripts/native_share_invoker.gd)
OS-level native share sheet integration for social features.

### [platform_mobile_patterns.gd](scripts/platform_mobile_patterns.gd) / [mobile_safe_area_handler.gd](scripts/mobile_safe_area_handler.gd)
Additional patterns / legacy safe-area helper — load only if golden-path scripts insufficient.

---

## Decision tree (before implementation)

| Axis | Choose | Implies |
|------|--------|---------|
| **Control scheme** | Tap/gesture vs virtual stick vs tilt | Gestures → `mobile_gesture_recognizer.gd`; stick → built-in joystick / Control stick; tilt → `mobile_sensor_fusion.gd` |
| **Orientation** | Locked landscape / portrait / adaptive | Adaptive → **MANDATORY** `orientation_layout_adaptor.gd` + `size_changed` |
| **Renderer** | **Mobile** vs **Compatibility** | Never Forward+ on phone GPUs; ETC2/ASTC on; precompile shaders on load screens |

Touch input uses `InputEventScreenTouch` / `InputEventScreenDrag` — not mouse emulation.

## Project settings (mobile)

```ini
[rendering]
renderer/rendering_method="mobile"
textures/vram_compression/import_etc2_astc=true

[display]
window/handheld/orientation="landscape"
```

## App Store Metadata

- Icons: 512×512 (Android), 1024×1024 (iOS); multi-res screenshots; privacy policy; age rating.

## Ship-gate checks (WHY)

1. **ANR I/O** — Large saves/loads on the main thread trip Android ANR. WHY: OS kills unresponsive apps. Gate: background threads / `WorkerThreadPool` for disk I/O.
2. **Pause FPS** — Backgrounded apps left at 60 FPS drain battery and heat the SoC. WHY: `NOTIFICATION_APPLICATION_PAUSED` must drop `Engine.max_fps` (see `thermal_throttle_monitor.gd`).
3. **Permission timing** — Request Android permissions at the feature moment (mic, photos), not on cold boot. WHY: Play policy + user trust; verify with `OS.get_granted_permissions()` via `android_runtime_permissions.gd`.

## Expert notes (script-first)

- Android Back: disable `quit_on_go_back`, handle `NOTIFICATION_WM_GO_BACK_REQUEST` in [mobile_navigation_manager.gd](scripts/mobile_navigation_manager.gd).
- Haptics: [haptic_pattern_generator.gd](scripts/haptic_pattern_generator.gd) / [mobile_haptics.gd](scripts/mobile_haptics.gd) + export `VIBRATE` permission.
- Shader hitch: [mobile_shader_precompiler.gd](scripts/mobile_shader_precompiler.gd); prefer `godot-shaders-basics` for deep precompile recipes.

## Deep dives (on demand)

- Touch/joystick, safe area, Android back, haptics, shader precompile → [mobile-touch-and-expert.md](references/mobile-touch-and-expert.md)

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event pipeline that makes `InputEventScreenTouch` / `InputEventScreenDrag` the correct mobile path instead of mouse-button emulation.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Multi-touch, drag, and gesture patterns behind virtual joysticks, pinch/rotate, and swipe HUDs.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — `NOTIFICATION_APPLICATION_PAUSED` / resume and Android back (`WM_GO_BACK_REQUEST`) lifecycle that replaces desktop quit assumptions.
- [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html) — `get_display_safe_area()`, orientation, and virtual keyboard APIs for notches, foldables, and OSK occlusion.
- [OS](https://docs.godotengine.org/en/stable/classes/class_os.html) — `request_permission()` / `get_granted_permissions()`, feature tags, and memory queries used by Android runtime gates and VRAM watchdogs.
- [Input](https://docs.godotengine.org/en/stable/classes/class_input.html) — `vibrate_handheld()`, accelerometer/gravity/gyroscope fusion, and touch↔mouse emulation toggles.
- [Exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) — Permissions (including `VIBRATE`), APK/AAB, and store packaging constraints after platform code is ready.
- [Exporting for iOS](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html) — Xcode export, capabilities, and App Store gates that catch missing privacy/plugin setup late.
- [Android in-app purchases](https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html) — Official Play Billing flow that the IAP boilerplate script abstracts with iOS store plugins.
- [Introduction to the 3 rendering methods](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html) — Why mobile builds should prefer **Mobile** or **Compatibility** over Forward+ for fill-rate and feature set.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch modes, content scale, and orientation-safe layouts for phone/tablet aspect changes.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — `mobile` / `android` / `ios` branching for permissions, share sheets, and platform-only singletons.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Shared InputEvent buffering, multi-touch indices, and deadzones before shipping gesture recognizers or virtual sticks.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Anchors, Margin/Box containers, and minimum sizes so safe-area insets and 44–48px touch targets stay layout-correct.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Feature tags, display stretch, and renderer defaults every Android/iOS export branch depends on.

#### Complements
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Desktop→touch control remap, joystick spawners, and UI scaling that pair with this skill's deeper OS/permission APIs.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and CPU/GPU cuts when thermal FPS caps and ETC2/ASTC alone still miss mid-range budgets.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Durable save ownership hooked to pause/resume instead of desktop-only quit notifications.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton homes for permissions, haptics, thermal monitors, and always-on pause handlers.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Bus mute/duck on `APPLICATION_PAUSED` so background audio does not keep the device warm.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Cheaper CanvasItem/Spatial shader paths and precompile strategies that avoid mobile hitch spikes.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Smooth UI lifts when the OS virtual keyboard covers LineEdits during mobile text entry.
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Keep mouse/keyboard paths correct when the same project remains dual-input beside mobile feature tags.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Signing, CI presets, and store packaging after touch/safe-area/permission gates pass on devices.
- [godot-genre-puzzle](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md) — Tap/swipe/pinch control schemes that consume mobile gesture and safe-area HUD patterns.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Soft/hard currency and receipt-validated IAP products once Play Billing / App Store plugins are wired.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this platform skill beside sibling domains.
