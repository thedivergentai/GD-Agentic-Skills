# Desktop Port Deep Recipes (load on demand)

> **MANDATORY** when SKILL.md port procedure / input decision tree is not enough. Prefer `scripts/*.gd`.

## When to open this file
- Input remap conflicts after `desktop_input_adapter.gd` vs `mouse_capture_look.gd` vs `hover_bridge.gd`
- Window mode / multi-monitor ordering after `dynamic_window_manager.gd` + `multi_monitor_handling.gd`
- Settings persistence after `resolution_dropdown.gd` + `uncapped_framerate.gd` + ConfigFile
- Quit/save races after `quit_confirmation.gd`
- Graphics quality ladder / MSAA / shadow atlas beyond script one-liners

## Control scheme expansion

**WHY bridge, not rewrite:** `desktop_input_adapter.gd` maps touch actions → WASD/mouse without forking gameplay movers. FPS/orbit look needs captured relative motion — when adapter emits `mouse_look_bridge_requested`, enable [mouse_capture_look.gd](../scripts/adapt_mobile_to_desktop_mouse_capture_look.gd).

| Mobile | Desktop equivalent |
|--------|-------------------|
| Virtual joystick | `Input.get_vector` on WASD actions |
| Touch aim | Mouse position / captured look |
| Pinch zoom | [scroll_wheel_zoom.gd](../scripts/adapt_mobile_to_desktop_scroll_wheel_zoom.gd) |
| On-screen buttons | Keyboard shortcuts + hover tooltips ([hover_bridge.gd](../scripts/adapt_mobile_to_desktop_hover_bridge.gd)) |

Keyboard shortcuts (F11 fullscreen, F5 quick-save, I/Tab inventory) belong in InputMap — persist remaps via [keybinding_remapper.gd](../scripts/adapt_mobile_to_desktop_keybinding_remapper.gd).

## Graphics enhancement

**WHY not mobile base resolution:** Desktop expects 1080p–4K, higher draw distance, and user-controlled quality.

On PC `ready`:
1. Query `DisplayServer.screen_get_size()` for default window size
2. Enable MSAA (`Viewport.MSAA_2X` / `MSAA_4X`), FXAA, larger shadow atlas via `RenderingServer.directional_shadow_atlas_set_size`
3. Unlock FPS — [uncapped_framerate.gd](../scripts/adapt_mobile_to_desktop_uncapped_framerate.gd) — match refresh or `Engine.max_fps = 0` with VSync toggle

Settings menu pattern: OptionButton resolutions + quality preset + VSync/fullscreen checkboxes → `ConfigFile` at `user://settings.cfg`. Load on boot before main scene if using a lightweight launcher.

## UI layout expansion

| Mobile | Desktop |
|--------|---------|
| Large touch targets (44pt+) | [desktop_ui_scaler.gd](../scripts/adapt_mobile_to_desktop_desktop_ui_scaler.gd) — shrink 30–50% |
| Virtual joystick visible | Hide; WASD only |
| Minimap hidden (clutter) | Show top-right ~200×200 |
| Compact HUD | Hotbar center-bottom, chat bottom-left |

Branch with `OS.has_feature("mobile")` or export feature tags — do not ship thumb-sized buttons on PC.

## Window management

[dynamic_window_manager.gd](../scripts/adapt_mobile_to_desktop_dynamic_window_manager.gd) — windowed / exclusive fullscreen / borderless.

Borderless recipe: set window size to screen size, position `(0,0)`, `WINDOW_FLAG_BORDERLESS` — distinct from exclusive fullscreen on multi-monitor setups.

[multi_monitor_handling.gd](../scripts/adapt_mobile_to_desktop_multi_monitor_handling.gd) — launch on screen under cursor; center with `screen_get_position` + `screen_get_size`.

## Platform services (Steam / Discord)

Follow the GDExtension decision tree in SKILL.md — do not paste fake `Steam.*` stubs into gameplay.

- Init behind `OS.has_feature("steam")` or editor-safe stubs
- Rich presence: thin Autoload on scene change — never block `_ready` on network
- No store milestone → omit code paths entirely

## Performance unlocks

| Mobile default | Desktop port |
|----------------|--------------|
| `Engine.max_fps = 60` | Uncapped or match `screen_get_refresh_rate()` |
| Low camera `far` | 300–500+; increase directional shadow distance |
| Fixed quality | Quality ladder persisted in ConfigFile |

Optional: 5s FPS benchmark → write `user://override.cfg` disabling SSAO/SDFGI half-res when avg FPS < 30.

## Standalone launcher (optional)

Lightweight first scene saves `user://settings.cfg`, then `OS.create_process(executable, ["--main-pack", "game_data.pck"])` and quits — keeps main pack clean for heavy titles.

## Do NOT Load
- Touch-only joystick tutorials — mobile leftovers
- Full OS desktop APIs — route to godot-platform-desktop after input/UI/window gates pass
