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
