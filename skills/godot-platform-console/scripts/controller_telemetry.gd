class_name ControllerTelemetry extends Node
## Tracks controller states and hardware metadata.

func _ready() -> void:
    Input.joy_connection_changed.connect(_on_joy_changed)

func _on_joy_changed(id: int, connected: bool) -> void:
    if connected:
        var info := Input.get_joy_info(id)
        # Tracks hardware GUID and XInput index for telemetry logs.
        print("Controller %d: %s" % [id, info.get("xinput_index", "Native")])
