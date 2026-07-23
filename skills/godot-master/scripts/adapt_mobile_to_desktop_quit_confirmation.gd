extends Node
class_name QuitConfirmationHandler

## Expert PC Desktop Window State interceptor
## Unlike mobile iOS/Android where swiping away means immediate termination,
## PC users pressing the 'X' window button expect a "Are you sure you want to quit?" dialog
## to save their progress!

@export var confirmation_dialog: ConfirmationDialog

func _ready() -> void:
    # We must explicitly tell the OS we want to handle the quit request ourselves
    # Otherwise Godot simply closes immediately upon clicking 'X'
    get_tree().set_auto_accept_quit(false)

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        print("X clicked. Showing confirmation popup...")
        
        # Pause the game in the background
        get_tree().paused = true
        
        confirmation_dialog.popup_centered()
        
func _on_save_and_quit_pressed() -> void: # Connected via Editor Signal
    # Wait for file saving to conclude...
    # ...
    
    # Finally explicitly quit
    get_tree().quit()

func _on_cancel_quit_pressed() -> void: # Connected via Editor Signal
    get_tree().paused = false
    confirmation_dialog.hide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — save prompt before quit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — WM close button expectations
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-mobile-to-desktop/SKILL.md
# =============================================================================
