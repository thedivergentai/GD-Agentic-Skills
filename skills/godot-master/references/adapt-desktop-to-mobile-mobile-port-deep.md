# Mobile Port Deep Recipes (load on demand)

> **MANDATORY** only when the SKILL.md decision matrix / port procedure is not enough. Prefer `scripts/*.gd` over copying prose.

## When to open this file
- Dual-stick / genre control edge cases after reading `dynamic_joystick_spawner.gd` / `gesture_combo_system.gd`
- Safe-area + HUD thumb-reach conflicts after `mobile_ui_adapter.gd` + `ui_safe_area_margins.gd`
- Thermal/FPS recovery after `resolution_scaler.gd` + `mobile_shader_fallback.gd`
- Pause/kill save races after `battery_saver_mode.gd` + `offline_save_sync.gd`

## Do NOT Load
- Full Android/iOS platform APIs — route to godot-platform-mobile after control/UI/perf gates pass
- Desktop mouse/hover recipes — already invalid on mobile (see NEVER in SKILL.md)

## Script-first checklist
1. Map genre → control script (decision matrix in SKILL.md)
2. Apply safe-area + UI adapter before art polish
3. Hook pause FPS lock + offline save
4. Scale 3D + strip heavy materials until device FPS holds
