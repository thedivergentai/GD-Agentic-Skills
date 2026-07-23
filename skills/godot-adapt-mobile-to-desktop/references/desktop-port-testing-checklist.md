# Desktop Port Testing Checklist (load on demand)

> **MANDATORY** before declaring a mobile→desktop port complete — run every row on target PC hardware.

## Input & aim
- [ ] Mouse controls feel precise (no acceleration issues)
- [ ] All mobile touch controls have keyboard/mouse equivalents via `desktop_input_adapter.gd`
- [ ] FPS / orbit look uses `mouse_capture_look.gd` when decision tree routes aim/Look there (adapter alone is not enough)
- [ ] Pinch zoom replaced by `scroll_wheel_zoom.gd` where applicable
- [ ] Rebindable keys persist via `keybinding_remapper.gd`

## UI & hover
- [ ] `desktop_ui_scaler.gd` shrinks thumb-sized Controls without layout breaks
- [ ] `hover_bridge.gd` restores hover/focus affordances on menus and tooltips
- [ ] Expanded desktop HUD (hotbar/chat/minimap) fits at 1080p and ultrawide

## Window & graphics
- [ ] Graphics settings menu works correctly
- [ ] Fullscreen, windowed, and borderless modes function (`dynamic_window_manager.gd`)
- [ ] Multi-monitor placement works (`multi_monitor_handling.gd`)
- [ ] Resolution changes do not crash or distort UI (`resolution_dropdown.gd`)
- [ ] VSync toggle works (`uncapped_framerate.gd`)
- [ ] Settings persist across sessions (ConfigFile)

## Quit & save
- [ ] Quit confirmation can save (`quit_confirmation.gd` + `set_auto_accept_quit(false)`)

## Do NOT Load
- Touch-only joystick tutorials — mobile leftovers
- Full OS desktop APIs — route to godot-platform-desktop after this checklist passes
