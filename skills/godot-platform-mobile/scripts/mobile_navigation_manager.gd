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
