extends Node
class_name BatterySaverMode

## Expert Mobile Battery Management
## When the user swipes up or puts the phone to sleep, the OS pauses the app.
## If not handled carefully, continuous calculations will drain the battery and the OS will kill the app.

func _ready() -> void:
    # Runs during all pauses so it can listen for resumes
    process_mode = Node.PROCESS_MODE_ALWAYS

func _notification(what: int) -> void:
    match what:
        NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_WINDOW_FOCUS_OUT:
            _on_app_backgrounded()
        NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_WM_WINDOW_FOCUS_IN:
            _on_app_foregrounded()

func _on_app_backgrounded() -> void:
    # 1. Pause game logic and physics
    get_tree().paused = true
    
    # 2. Aggressively drop frame rate to save GPU/CPU cycles
    # Godot will render 1 frame per second to keep the OS snapshot looking correct
    Engine.max_fps = 1 
    
    # 3. Mute all master volume so it doesn't try to play over music
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
    
    print("BatterySaver: App suspended. Physics paused, FPS locked to 1.")

func _on_app_foregrounded() -> void:
    # Resume everything
    get_tree().paused = false
    
    # Setting to 0 unlocks the framerate (or locks to VSync)
    Engine.max_fps = 0 
    
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
    print("BatterySaver: App resumed. Physics active, FPS restored.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — APPLICATION_PAUSED thermal/battery patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — PROCESS_MODE_ALWAYS singleton
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md
# =============================================================================
