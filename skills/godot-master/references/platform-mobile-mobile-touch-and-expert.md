# Mobile touch and expert patterns

> Virtual joystick, responsive UI, safe-area snippets, Android back stack, haptics, shader precompile.

## Touch input

```gdscript
# Replace mouse/keyboard with touch
func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            on_touch_start(event.position)
        else:
            on_touch_end(event.position)
    
    elif event is InputEventScreenDrag:
        on_touch_drag(event.position, event.relative)
```

## Virtual Joystick

```gdscript

## Responsive UI

```gdscript

## Battery Optimization

```gdscript

## Safe Areas (Notches)

```gdscript
func apply_safe_area() -> void:
    var safe_area := DisplayServer.get_display_safe_area()
    
    # Adjust UI margins
    $UI.offset_top = safe_area.position.y
    $UI.offset_left = safe_area.position.x
```

## Performance Settings

```ini

### 1. Android-Back-Button Handler (Navigation-Stack Popping)
Intercept the Android hardware Back button to pop a UI navigation stack. Disable `SceneTree.quit_on_go_back` and listen for `NOTIFICATION_WM_GO_BACK_REQUEST` in a global manager.

```gdscript
class_name MobileNavigationManager extends Node
## Autoload: Intercepts the Android Back button to pop UI screens.

var _ui_stack: Array[Control] = []

func _ready() -> void:
    # Stop the app from quitting immediately
    get_tree().set_quit_on_go_back(false)

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        if _ui_stack.size() > 0:
            var screen := _ui_stack.pop_back()
            screen.hide()
        else:
            get_tree().quit()
```

### 2. Vibration-Intensity Haptic Profiles
Create nuanced haptic profiles by defining specific amplitudes and durations. For Android, ensure the `VIBRATE` permission is enabled in the export preset.

```gdscript
class_name MobileHaptics extends Node
## Executes predefined haptic feedback profiles.

func play_light_haptic() -> void:
    # 30ms duration, 20% strength
    Input.vibrate_handheld(30, 0.2)

func play_heavy_haptic() -> void:
    # 400ms duration, 100% strength
    Input.vibrate_handheld(400, 1.0)
```

### 3. Mobile-Shader-Precompiler (Prevent Frame-Hitches)
To avoid shader compilation stutter, force the GPU to compile pipelines during a loading screen. For Forward+/Mobile renderers, instance hidden effects. For Compatibility, force-draw them in the camera frustum for one frame.

```gdscript
class_name MobileShaderPrecompiler extends Node3D
## Forces RenderingServer to compile pipelines during loading.

@export var effects_to_precompile: Array[PackedScene] = []

func _ready() -> void:
    for scene in effects_to_precompile:
        var instance := scene.instantiate() as Node3D
        add_child(instance)
        # Hidden nodes trigger compilation in Forward+/Mobile
        instance.hide() 
        
    # Compatibility renderer needs one visible frame in frustum
    if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
        for child in get_children():
            child.show()
            child.position = Vector3(0, 0, -2) # In front of camera
        await get_tree().process_frame
        for child in get_children(): child.queue_free()
```
