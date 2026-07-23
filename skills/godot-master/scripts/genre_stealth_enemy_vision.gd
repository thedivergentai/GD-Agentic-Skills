class_name EnemyVision
extends Node3D

@export var forward_vision_range := 20.0    # Main vision cone
@export var peripheral_range := 10.0        # Side vision
@export var forward_fov := 60.0             # Degrees
@export var peripheral_fov := 120.0          # Degrees
@export var detection_speed := 1.0          # How fast detection builds

var detection_level := 0.0  # 0-100
var target: Node3D = null

func _physics_process(delta: float) -> void:
    var player := get_player_if_visible()
    if player:
        # Detection rate varies by:
        # - Distance (closer = faster)
        # - Lighting on player
        # - Player movement (moving = more visible)
        # - In peripheral vs direct vision
        var rate := calculate_detection_rate(player)
        detection_level = min(100, detection_level + rate * delta)
    else:
        detection_level = max(0, detection_level - detection_speed * 0.5 * delta)

func get_player_if_visible() -> Player:
    var player := get_tree().get_first_node_in_group("player")
    if not player:
        return null
    
    var to_player := player.global_position - global_position
    var distance := to_player.length()
    var angle := rad_to_deg(global_basis.z.angle_to(-to_player.normalized()))
    
    # Check forward cone
    if angle < forward_fov / 2.0 and distance < forward_vision_range:
        if has_line_of_sight(player):
            return player
    
    # Check peripheral (less effective)
    elif angle < peripheral_fov / 2.0 and distance < peripheral_range:
        if has_line_of_sight(player):
            return player
    
    return null

func calculate_detection_rate(player: Player) -> float:
    var distance := global_position.distance_to(player.global_position)
    var distance_factor := 1.0 - (distance / forward_vision_range)
    
    var light_factor := player.get_light_level()  # 0.0 = dark, 1.0 = lit
    var movement_factor := 1.0 if player.velocity.length() > 0.5 else 0.3
    
    return detection_speed * distance_factor * light_factor * movement_factor * 50.0
