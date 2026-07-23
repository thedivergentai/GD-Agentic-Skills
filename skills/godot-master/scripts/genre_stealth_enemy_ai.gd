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
