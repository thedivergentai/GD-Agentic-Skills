# AI Alert States

Three-phase system (industry standard):

```gdscript
enum AlertState { IDLE, SUSPICIOUS, ALERTED, COMBAT }

class_name EnemyAI
extends CharacterBody3D

var alert_state := AlertState.IDLE
var suspicion_point: Vector3
var search_timer := 0.0

signal alert_state_changed(new_state: AlertState)

func transition_to(new_state: AlertState) -> void:
    alert_state = new_state
    alert_state_changed.emit(new_state)
    
    match new_state:
        AlertState.SUSPICIOUS:
            play_animation("suspicious")
            speak_dialogue("what_was_that")
        AlertState.ALERTED:
            speak_dialogue("who_goes_there")
            # Other guards in range hear and become suspicious
            alert_nearby_guards()
        AlertState.COMBAT:
            speak_dialogue("intruder")
            trigger_alarm()
```

### Visual Feedback (Critical!)

```gdscript
class_name AlertIndicator
extends Node3D

@export var idle_icon: Texture2D
@export var suspicious_icon: Texture2D  # "?" 
@export var alerted_icon: Texture2D     # "!"
@export var detection_meter: ProgressBar  # Shows filling detection

func update_indicator(state: AlertState, detection: float) -> void:
    detection_meter.value = detection
    
    match state:
        AlertState.IDLE:
            icon.texture = idle_icon
            detection_meter.visible = false
        AlertState.SUSPICIOUS:
            icon.texture = suspicious_icon
            detection_meter.visible = true
        AlertState.ALERTED:
            icon.texture = alerted_icon
            detection_meter.visible = false
```

---
