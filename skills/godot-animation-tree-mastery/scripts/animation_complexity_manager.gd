class_name AnimationComplexityManager extends Node3D

@export var hero_tree: AnimationRootNode   # Complex StateMachine
@export var crowd_tree: AnimationRootNode  # Simple Looping Idle

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var visibility: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

func _ready() -> void:
    visibility.screen_entered.connect(func(): anim_tree.tree_root = hero_tree)
    visibility.screen_exited.connect(func(): anim_tree.tree_root = crowd_tree)
