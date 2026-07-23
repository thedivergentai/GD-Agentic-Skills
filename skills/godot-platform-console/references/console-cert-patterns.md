# Console input and certification patterns

> Joypad snippets, platform overlay dialogs, shader binary cache, controller telemetry.

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
