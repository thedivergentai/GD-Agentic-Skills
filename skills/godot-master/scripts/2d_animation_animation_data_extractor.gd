class_name AnimationDataExtractor extends CharacterBody2D

# 1. Define the metadata property (Value Track target)
@export var current_spawn_offset: Vector2 = Vector2.ZERO:
    set(value):
        current_spawn_offset = value
        _update_spawn_point()

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_marker: Marker2D = $SpawnMarker

func _ready() -> void:
    # Playing via AnimationPlayer updates 'current_spawn_offset' on keyed frames
    anim_player.play("attack_shoot")

func _update_spawn_point() -> void:
    spawn_marker.position = current_spawn_offset

# 2. Call Method Track Implementation
# Use this to pass complex arguments directly to a function on a specific frame
func spawn_projectile(damage: int, specific_offset: Vector2) -> void:
    var projectile = PROJECTILE_SCENE.instantiate()
    projectile.damage = damage
    projectile.position = global_position + specific_offset
    get_parent().add_child(projectile)
