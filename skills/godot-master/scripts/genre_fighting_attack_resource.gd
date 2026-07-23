# attack_resource.gd
class_name Attack
extends Resource

@export var name: String
@export var startup_frames: int  # Frames before hitbox becomes active
@export var active_frames: int   # Frames hitbox is active
@export var recovery_frames: int # Frames after hitbox deactivates
@export var on_hit_advantage: int # Frame advantage when attack hits
@export var on_block_advantage: int # Frame advantage when blocked
@export var damage: int
@export var hitstun: int  # Frames opponent is stunned
@export var blockstun: int # Frames opponent is in blockstun

func get_total_frames() -> int:
    return startup_frames + active_frames + recovery_frames

func is_safe_on_block() -> bool:
    return on_block_advantage >= 0
