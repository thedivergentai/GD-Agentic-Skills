# Mobile Port Deep Recipes (load on demand)

> **MANDATORY** only when the SKILL.md decision matrix / port procedure is not enough. Prefer `scripts/*.gd` over copying prose.

## When to open this file

- Dual-stick / genre control edge cases after `dynamic_joystick_spawner.gd` / `gesture_combo_system.gd`
- Safe-area + HUD thumb-reach conflicts after `mobile_ui_adapter.gd` + `ui_safe_area_margins.gd`
- Thermal/FPS recovery after `resolution_scaler.gd` + `mobile_shader_fallback.gd`
- Pause/kill save races after `battery_saver_mode.gd` + `offline_save_sync.gd`
- Responsive HUD aspect splits beyond the decision matrix

## Do NOT Load

- Full Android/iOS platform APIs — route to [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) after control/UI/perf gates pass
- Desktop mouse/hover recipes — invalid on mobile (see NEVER in SKILL.md)

## Touch controls (script-first)

| Pattern | Script |
|---------|--------|
| Dynamic move stick (left half) | [dynamic_joystick_spawner.gd](../scripts/adapt_desktop_to_mobile_dynamic_joystick_spawner.gd) |
| Fixed-base stick | [virtual_joystick.gd](../scripts/adapt_desktop_to_mobile_virtual_joystick.gd) |
| Swipe / pinch / tap | [gesture_combo_system.gd](../scripts/adapt_desktop_to_mobile_gesture_combo_system.gd) |
| Camera pan + pinch | [touch_camera_pan_zoom.gd](../scripts/adapt_desktop_to_mobile_touch_camera_pan_zoom.gd) |

> **WHY dynamic spawner:** Fixed joysticks fail on different hand sizes; spawn-at-touch avoids dead zones at screen edges.

## UI scaling and thumb reach

[mobile_ui_adapter.gd](../scripts/adapt_desktop_to_mobile_mobile_ui_adapter.gd) + [ui_safe_area_margins.gd](../scripts/adapt_desktop_to_mobile_ui_safe_area_margins.gd):

- Minimum touch target **88px** on Retina (44pt × 2) — Apple HIG 44pt, Material 48dp.
- Ultra-wide (`aspect > 2`): spread controls to edges.
- Tall phone (`aspect < 0.6`): anchor controls above bottom safe area — finger occlusion is **50–100px**.
- Group buttons as `touch_buttons` for batch `custom_minimum_size` updates on `size_changed`.

## Performance (mobile GPUs)

[resolution_scaler.gd](../scripts/adapt_desktop_to_mobile_resolution_scaler.gd) + [mobile_shader_fallback.gd](../scripts/adapt_desktop_to_mobile_mobile_shader_fallback.gd):

- Disable MSAA / screen-space AA on weak devices.
- Halve particle `amount` where possible.
- Consider `Engine.physics_ticks_per_second = 30` only after profiling — hurts feel if applied blindly.
- Adaptive loop: if FPS < target − 10 for 2s, step `scaling_3d_scale` down (0.5 / 0.75 / 1.0).

## Battery and lifecycle

[battery_saver_mode.gd](../scripts/adapt_desktop_to_mobile_battery_saver_mode.gd) on `NOTIFICATION_APPLICATION_PAUSED`:

- `Engine.max_fps = 1–5`, pause tree, mute Master bus.
- OS kills background drainers — never leave 60 FPS physics running when backgrounded.

[offline_save_sync.gd](../scripts/adapt_desktop_to_mobile_offline_save_sync.gd): `NOTIFICATION_WM_CLOSE_REQUEST` is unreliable on mobile kill — persist on pause.

## Input remapping

Support **both** mouse (desktop test) and touch in `_input`:

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        _on_tap(event.position)
    elif event is InputEventScreenTouch and event.pressed:
        _on_tap(event.position)
```

## Edge cases

| Problem | Mitigation |
|---------|------------|
| OSK covers LineEdit | [on_screen_keyboard_handler.gd](../scripts/adapt_desktop_to_mobile_on_screen_keyboard_handler.gd) tweens UI up |
| Palm touches screen edge | Ignore touches within ~50px of viewport border |
| Dual-stick index clash | Track `event.index` per stick — see gesture script |
| Notch clips HUD | `DisplayServer.get_display_safe_area()` margins |

## Testing checklist (device, not editor)

- [ ] Fat-finger test on target hardware
- [ ] Critical HUD above touch controls (occlusion)
- [ ] Pause + save on background
- [ ] Stable FPS on iPhone 12 / Galaxy S21 class devices
- [ ] Battery < ~10%/hour in gameplay session
- [ ] Safe area in portrait and landscape
- [ ] Readable text on smallest target (e.g. iPhone SE)

## Store / debug utilities

Screenshot after draw (store assets):

```gdscript
await RenderingServer.frame_post_draw
get_viewport().get_texture().get_image().save_png("user://screenshots/frame.png")
```

Memory overlay: `OS.get_memory_info()` — avoid heavy allocations while polling (see SKILL.md Expert Techniques).

## IAP note

Platform billing singletons differ (Android vs iOS). Abstract behind one manager in [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — do not paste store SDKs into gameplay scenes.
