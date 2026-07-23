# Mobile Port Checklist (load on demand)

> **MANDATORY** at step 1 of the Desktop→Mobile port procedure — confirm each gate before deeper platform work.

## Pre-port inventory
- [ ] List every desktop-only input path (hover, right-click, scroll, keyboard shortcuts)
- [ ] List every LineEdit/TextEdit that needs OSK handling
- [ ] Note genre control scheme from SKILL.md decision matrix
- [ ] Confirm save hooks exist for pause/kill (not WM_CLOSE-only)

## Control remap gates
- [ ] Touch actions replace mouse position / hover assumptions
- [ ] Genre stick/gesture script chosen (`dynamic_joystick_spawner`, `gesture_combo_system`, or tap-only)
- [ ] Dual-stick index conflicts reviewed if using two virtual sticks
- [ ] Critical HUD placed above finger occlusion zone

## UI & safe area
- [ ] `ui_safe_area_margins.gd` applied to root HUD
- [ ] `mobile_ui_adapter.gd` scales Controls to 44–48dp minimum targets
- [ ] Text fields use `on_screen_keyboard_handler.gd` (not mobile_ui_adapter alone)

## Lifecycle & perf
- [ ] `battery_saver_mode.gd` on `NOTIFICATION_APPLICATION_PAUSED`
- [ ] `offline_save_sync.gd` persists on pause/resume
- [ ] `resolution_scaler.gd` + `mobile_shader_fallback.gd` until device FPS holds

## Do NOT Load
- Full Android/iOS platform APIs — route to godot-platform-mobile after the gates above pass
- Deep dual-stick recipes — see `mobile-port-deep.md` only when matrix + scripts are insufficient
