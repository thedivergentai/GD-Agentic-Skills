---
name: godot-platform-console
description: "Expert blueprint for console platforms (PlayStation, Xbox, Nintendo Switch) covering controller-first UI, certification requirements (TRCs/TCRs), platform services (achievements, cloud saves), and performance compliance. Use when targeting console releases or implementing gamepad-only interfaces. Keywords console, PlayStation, Xbox, Switch, TRC, TCR, certification, controller, gamepad, achievements."
---

# Platform: Console

Controller-first design, certification compliance, and locked frame rates define console development.

## NEVER Do

- **NEVER show a mouse cursor** — Showing a cursor on a console is a certification (TRC/TCR) failure. Hide it using `Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)`.
- **NEVER skip pausing on focus loss** — If a player presses the Home button and the game keeps running, it's a certification violation. Monitor `NOTIFICATION_APPLICATION_FOCUS_OUT` and force a pause.
- **NEVER use an unlocked frame rate** — Variable FPS leads to screen tearing and rejections. Lock specifically to 30 or 60 FPS using `Engine.max_fps` and enable VSync.
- **NEVER forget D-Pad navigation** — UI that is only navigable with an analog stick is an accessibility failure. Always support D-Pad inputs for all menu interactions.
- **NEVER hardcode button labels** — Displaying "Press A" on a PlayStation controller is a major mistake. Use `Input.get_joy_button_string()` or dynamic icon mapping based on the controller's GUID.
- **NEVER exceed hardware memory limits** — Consoles (especially Switch) have very rigid RAM budgets. Exceeding them causes OS-level crashes. Profile strictly using the memory tab in the Godot Profiler.
- **NEVER assume Joypad 0 is always Player 1** — Users may connect controllers in any order. Always query active connections dynamically using `Input.get_connected_joypads()`.
- **NEVER distribute console export templates or SDKs publicly** — Console SDKs are strictly under Non-Disclosure Agreements (NDAs). Leaking these can lead to legal action and developer banishment.
- **NEVER handle continuous analog stick input using boolean checks** — Using `is_action_pressed()` for sticks ignores deadzones and precision. Use `get_vector()` or `get_action_strength()` for smooth movement.
- **NEVER vibrate controllers continuously without an option to disable it** — Always use `Input.start_joy_vibration()` with finite durations and provide an accessibility toggle to turn off haptics.
- **NEVER expect traditional OS window manipulation to function on consoles** — Consoles operate in fixed fullscreen environments. Methods like `DisplayServer.window_set_mode()` will typically fail or be ignored.
- **NEVER map UI interactions manually to raw button indices** — Always utilize the Project Input Map (u_accept, u_cancel). This allows Godot to dynamically route gamepad events regardless of the specific hardware.
- **NEVER rely on NOTIFICATION_WM_CLOSE_REQUEST for termination** — Consoles often use background suspension (similar to mobile) rather than explicit window closing.
- **NEVER query inputs without flushing buffered events for frame-perfect logic** — Use `Input.flush_buffered_events()` before critical checks to ensure responsiveness.
- **NEVER use == or != to evaluate analog trigger axes** — Floating-point precision loss makes exact equality comparison unreliable. Use `is_equal_approx()` for analog values.
- **NEVER leave orphaned nodes in memory during scene transitions** — Strict RAM limits mandate aggressive cleanup. Always use `queue_free()` and avoid cyclic references that prevent garbage collection.

---

## Godot 4.7: Console Input

- Use `InputEvent.DEVICE_ID_*` constants — never assume device `0` is mouse/keyboard.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [certification_manager.gd](../scripts/platform_console_certification_manager.gd)
Expert TRC/TCR compliance (focus loss, controller disconnects).

### [performance_scaler_fsr.gd](../scripts/platform_console_performance_scaler_fsr.gd)
Dynamic Resolution Scaling and FSR 2.2 management for console performance.

### [server_side_projectile.gd](../scripts/platform_console_server_side_projectile.gd)
Direct RenderingServer/PhysicsServer bypass for high-frequency objects.

### [async_save_manager.gd](../scripts/platform_console_async_save_manager.gd)
Atomic, corruption-resistant threaded save system.

### [controller_prompt_mapper.gd](../scripts/platform_console_controller_prompt_mapper.gd)
GUID-based button prompt detection (PlayStation/Xbox/Switch).

### [memory_budget_guard.gd](../scripts/platform_console_memory_budget_guard.gd)
Strict RAM monitoring for platform-specific hardware budgets.

### [platform_dialog_invoker.gd](../scripts/platform_console_platform_dialog_invoker.gd)
Native OS dialog and virtual keyboard abstraction.

### [background_data_prefetcher.gd](../scripts/platform_console_background_data_prefetcher.gd)
Asset pre-fetching using WorkerThreadPool to avoid level-load stutters.

### [achievement_offline_queue.gd](../scripts/platform_console_achievement_offline_queue.gd)
Achievement/Trophy caching with offline persistence.

### [console_boot_config.gd](../scripts/platform_console_console_boot_config.gd)
Hardware-aware hardware initialization and rendering overrides.

---

## NEVER Do (Expert Console Rules)

### Certification & TRC
- **NEVER show a mouse cursor** — Rejection (TRC/TCR) failure. Hide using `Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)`.
- **NEVER skip pausing on focus loss** — Rejection violation. Monitor `NOTIFICATION_APPLICATION_FOCUS_OUT`.
- **NEVER let a controller disconnect go unhandled** — Must force pause and show "Reconnect Controller" UI.

### Performance & Hardware
- **NEVER use an unlocked frame rate** — Leads to tearing and instability. Lock specifically (30/60) using `Engine.max_fps`.
- **NEVER exceed hardware memory limits** — Switch has rigid RAM budgets. Monitor via `OS.get_static_memory_usage()`.
- **NEVER ignore VSync** — Console displays expect VSync. Always enable in `DisplayServer`.

### Architecture & Safety
- **NEVER assume Joypad 0 is Player 1** — Users switch slots. Query `Input.get_connected_joypads()` dynamically.
- **NEVER write to `res://` at runtime** — Rejection failure. Exported binaries are read-only. Strictly use `user://`.
- **NEVER save synchronously** — Main-thread stutters trigger TCR warnings. Offload to `WorkerThreadPool`.
- **NEVER skip atomic renames for saves** — Power loss mid-save must not corrupt data. Write to `.tmp` then rename.

## Input Handling

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventJoypadButton:
        match event.button_index:
            JOY_BUTTON_A:
                on_confirm()
            JOY_BUTTON_B:
                on_cancel()
```

## Performance Requirements

- **Locked 30/60 FPS** - No drops allowed
- **Memory limits** - Strict budgets
- **Certification testing** - QA required

## Platform Services

- Achievements/Trophies
- Cloud saves
- Multiplayer matchmaking
- Platform friends

## Best Practices

1. **Controller-Only** - No mouse/keyboard
2. **Pause on Focus Loss** - Required
3. **Save Prompts** - Must notify saves
4. **Certification** - Follow TRCs/TCRs
### 1. Platform-Overlay-Manager (Native UI Dialogs)
To comply with strict console certification (TRCs), avoid custom UI for critical system messages. Use `DisplayServer.dialog_show()` to invoke native platform dialogs, ensuring the message is handled by the OS.

```gdscript
class_name PlatformOverlayManager extends Node
## Invokes native OS dialogs for system compliance.

func show_native_alert(title: String, msg: String) -> void:
    if DisplayServer.has_feature(DisplayServer.FEATURE_SUBWINDOWS):
        # Native OS dialog integration.
        DisplayServer.dialog_show(title, msg, ["OK"], _on_dialog_closed)
    else:
        # Fallback to blocking OS alert.
        OS.alert(msg, title)

func _on_dialog_closed(button_index: int) -> void:
    print("Native dialog closed: ", button_index)
```

### 2. Shader-Binary-Caching (RenderingDevice)
Consoles use fixed hardware. Enable `rendering/shader_compiler/shader_cache/enabled` and use `RenderingDevice.shader_compile_binary_from_spirv()` to compile GPU-optimized binaries, reducing runtime stuttering.

```gdscript
class_name ConsoleShaderManager extends Node
## Manages GPU-specific shader binary compilation.

func get_device_uuid() -> String:
    var rd := RenderingServer.get_rendering_device()
    if rd:
        # Unique ID for the specific GPU and Driver.
        return rd.get_device_pipeline_cache_uuid()
    return ""
```

### 3. Controller-Battery-Telemetry Hook
Monitor controller health using `Input.joy_connection_changed` and `Input.get_joy_info()`. While battery level requires a platform-specific GDExtension, the telemetry hook queries the hardware identification string.

```gdscript
class_name ControllerTelemetry extends Node
## Tracks controller states and hardware metadata.

func _ready() -> void:
    Input.joy_connection_changed.connect(_on_joy_changed)

func _on_joy_changed(id: int, connected: bool) -> void:
    if connected:
        var info := Input.get_joy_info(id)
        # Tracks hardware GUID and XInput index for telemetry logs.
        print("Controller %d: %s" % [id, info.get("xinput_index", "Native")])
```

## Reference
- Related: `godot-export-builds`, `godot-input-handling`


### Related
- Master Skill: [godot-master](../SKILL.md)
