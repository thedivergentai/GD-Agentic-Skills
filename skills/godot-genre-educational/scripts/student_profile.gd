# student_profile.gd
class_name StudentProfile extends Resource

@export var topic_mastery: Dictionary = {} # "math_add": 0.5 (50%)
@export var total_xp: int = 0
@export var badges: Array[String] = []

func get_mastery(topic: String) -> float:
    return topic_mastery.get(topic, 0.0)
