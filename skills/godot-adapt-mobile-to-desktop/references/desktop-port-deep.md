# Desktop Port Deep Recipes (load on demand)

> **MANDATORY** only when SKILL.md port procedure / input decision tree is not enough. Prefer `scripts/*.gd`.

## When to open this file
- Input remap conflicts after `desktop_input_adapter.gd` vs `mouse_capture_look.gd` vs `hover_bridge.gd`
- Window mode / multi-monitor ordering after `dynamic_window_manager.gd` + `multi_monitor_handling.gd`
- Settings persistence after `resolution_dropdown.gd` + `uncapped_framerate.gd` + ConfigFile
- Quit/save races after `quit_confirmation.gd`

## Platform services (Steam / Discord)
Follow the GDExtension decision tree in SKILL.md — do not paste fake `Steam.*` stubs into gameplay.

## Do NOT Load
- Touch-only joystick tutorials — mobile leftovers
- Full OS desktop APIs — route to godot-platform-desktop after input/UI/window gates pass
