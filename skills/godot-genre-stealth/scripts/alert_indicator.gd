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
