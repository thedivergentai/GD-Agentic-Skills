# skills/genre-stealth/code/stealth_ai_controller.gd
extends CharacterBody3D

## Stealth AI Expert Pattern — matches SKILL NEVER:
## multi-sample PhysicsDirectSpaceState rays + RID exclude, path-length hearing.

enum State { IDLE, SUSPICIOUS, ALERT, COMBAT }
var current_state: State = State.IDLE

@export var detection_threshold: float = 100.0
@export var vision_samples: int = 3
@export var cone_half_angle_deg: float = 45.0
var alertness_meter: float = 0.0

@onready var player: Node3D = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	if _check_vision():
		var light_level := _get_player_light_level()
		alertness_meter += delta * 50.0 * light_level
	else:
		alertness_meter -= delta * 10.0
	alertness_meter = clampf(alertness_meter, 0.0, detection_threshold)
	_update_state()

func _check_vision() -> bool:
	if player == null:
		return false
	var origin := global_position + Vector3.UP * 1.6
	var to_player := player.global_position + Vector3.UP * 1.0 - origin
	var forward := -global_transform.basis.z
	if forward.normalized().dot(to_player.normalized()) < cos(deg_to_rad(cone_half_angle_deg)):
		return false
	var space := get_world_3d().direct_space_state
	var exclude: Array[RID] = [get_rid()]
	if player is CollisionObject3D:
		exclude.append((player as CollisionObject3D).get_rid())
	for i in vision_samples:
		var t := float(i) / float(maxi(vision_samples - 1, 1))
		var sample_to := origin.lerp(origin + to_player, 0.35 + 0.65 * t)
		var query := PhysicsRayQueryParameters3D.create(origin, sample_to)
		query.exclude = exclude
		var hit := space.intersect_ray(query)
		if not hit.is_empty():
			return false
	return true

func _get_player_light_level() -> float:
	if player and player.has_method("get_light_exposure"):
		return player.get_light_exposure()
	return 1.0

func on_sound_heard(sound_pos: Vector3, intensity: float) -> void:
	var path_len := _hearing_path_length(sound_pos)
	if path_len < 0.0:
		return
	var effective := intensity * 10.0 / maxf(path_len, 0.5)
	if effective < 0.15:
		return
	alertness_meter += intensity * 20.0 * effective
	if nav_agent:
		nav_agent.target_position = sound_pos

func _hearing_path_length(sound_pos: Vector3) -> float:
	var map_rid := get_world_3d().get_navigation_map()
	var path := NavigationServer3D.map_get_path(map_rid, global_position, sound_pos, true)
	if path.is_empty():
		return -1.0
	var length := 0.0
	for i in range(1, path.size()):
		length += path[i - 1].distance_to(path[i])
	return length

func _update_state() -> void:
	if alertness_meter >= detection_threshold:
		current_state = State.ALERT
	elif alertness_meter > 10.0:
		current_state = State.SUSPICIOUS
	else:
		current_state = State.IDLE

## EXPERT NOTE:
## Composite cones + 0.5s reaction delay still apply; implement delay in ALERT entry, not vision math.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — LoS and exclude RIDs for vision casts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — IDLE/SUSPICIOUS/ALERT/COMBAT transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune detection_threshold and cool-down rates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md
# =============================================================================
