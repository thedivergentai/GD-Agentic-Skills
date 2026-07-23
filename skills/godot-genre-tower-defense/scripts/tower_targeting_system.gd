extends Node3D
class_name TowerTargetingSystem

## Tower Targeting Expert Pattern
## Signal-cached targets + frame-sliced acquire + First/Last/Strongest/Weakest.

enum Priority { FIRST, LAST, STRONGEST, WEAKEST }
@export var target_priority: Priority = Priority.FIRST
@export var range: float = 10.0
@export var projectile_speed: float = 20.0
@export var acquire_interval_frames: int = 8
@export var range_area: Area3D  # body_entered / body_exited cache — NEVER get_overlapping every frame

var _current_target: Node3D = null
var _targets_in_range: Array[Node3D] = []
var _frame_offset: int = 0

func _ready() -> void:
	_frame_offset = randi() % max(1, acquire_interval_frames)
	if range_area:
		range_area.body_entered.connect(_on_body_entered)
		range_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies") and body not in _targets_in_range:
		_targets_in_range.append(body)

func _on_body_exited(body: Node3D) -> void:
	_targets_in_range.erase(body)
	if _current_target == body:
		_current_target = null

func _physics_process(_delta: float) -> void:
	# Frame-sliced acquire (BurstSearch pattern) — keep aim every frame
	if (Engine.get_process_frames() + _frame_offset) % max(1, acquire_interval_frames) == 0:
		_acquire_target()
	if _current_target and is_instance_valid(_current_target):
		_aim_at_target()
	else:
		_current_target = null

func _acquire_target() -> void:
	var potential: Array[Node3D] = []
	for enemy in _targets_in_range:
		if not is_instance_valid(enemy):
			continue
		if global_position.distance_squared_to(enemy.global_position) <= range * range:
			potential.append(enemy)
	if potential.is_empty():
		_current_target = null
		return
	match target_priority:
		Priority.FIRST:
			potential.sort_custom(func(a, b): return float(a.get("progress")) > float(b.get("progress")))
		Priority.LAST:
			potential.sort_custom(func(a, b): return float(a.get("progress")) < float(b.get("progress")))
		Priority.STRONGEST:
			potential.sort_custom(func(a, b): return float(a.get("health")) > float(b.get("health")))
		Priority.WEAKEST:
			potential.sort_custom(func(a, b): return float(a.get("health")) < float(b.get("health")))
	_current_target = potential[0]

func _aim_at_target() -> void:
	var target_pos = _current_target.global_position
	var target_vel = _current_target.velocity if "velocity" in _current_target else Vector3.ZERO
	var dist = global_position.distance_to(target_pos)
	var time_to_impact = dist / max(0.001, projectile_speed)
	var predicted_pos = target_pos + (target_vel * time_to_impact)
	var target_basis = Basis.looking_at(predicted_pos - global_position)
	global_basis = global_basis.slerp(target_basis, 0.1)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_pathfollow3d.html
# - https://docs.godotengine.org/en/stable/tutorials/math/vectors_advanced.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — lead prediction and priority targeting
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — First/Last/Strongest fairness under wave mixes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — 3D range and aim transforms
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md
# =============================================================================
