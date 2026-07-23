class_name BurstSearchTower extends Node2D

@export var search_interval_frames: int = 10
@export var attack_range: float = 250.0

var _frame_offset: int = 0
var _current_target: Node2D = null

func _ready() -> void:
    # Stagger search frame per tower
    _frame_offset = randi() % search_interval_frames

func _physics_process(_delta: float) -> void:
    # Execute expensive logic only once every N frames
    if (Engine.get_process_frames() + _frame_offset) % search_interval_frames == 0:
        _burst_search_for_target()

func _burst_search_for_target() -> void:
    var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
    # ... distance squared logic to pick closest target ...
