class_name StealthHUD
extends Control

@onready var visibility_meter: TextureProgressBar
@onready var sound_meter: TextureProgressBar
@onready var minimap: Control

func _process(_delta: float) -> void:
    visibility_meter.value = player.get_light_level() * 100
    sound_meter.value = player.current_noise_level * 100
