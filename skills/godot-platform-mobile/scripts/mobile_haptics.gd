class_name MobileHaptics extends Node
## Executes predefined haptic feedback profiles.

func play_light_haptic() -> void:
    # 30ms duration, 20% strength
    Input.vibrate_handheld(30, 0.2)

func play_heavy_haptic() -> void:
    # 400ms duration, 100% strength
    Input.vibrate_handheld(400, 1.0)
