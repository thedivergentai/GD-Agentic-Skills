class_name NetLagCompensation
extends Node

## Expert Server-Side Lag Compensation (Hit-Registration Rewind).
## Records history of hit-able entities and rewinds world state to validate client hits.

# Store ~1 second of history. At 60 TPS, 60 ticks.
const MAX_HISTORY_TICKS: int = 60 

# Structure: { tick_id (int) : { entity_rid (RID) : historical_transform (Transform3D) } }
var _state_history: Dictionary = {}

func _physics_process(_delta: float) -> void:
	# Server-side only logic
	if not multiplayer.is_server():
		return
		
	var current_tick := Engine.get_physics_frames()
	var current_state := {}
	
	# Record current state of all hit-able entities
	# Entities must be in the "lag_compensated" group to be tracked
	var entities := get_tree().get_nodes_in_group(&"lag_compensated")
	for entity in entities:
		if entity is Node3D:
			# We store the physics RID to update the server directly later for performance
			var rid: RID = entity.get_rid() 
			current_state[rid] = entity.global_transform
		
	_state_history[current_tick] = current_state
	
	# Prune old history to prevent memory leaks
	var oldest_tick := current_tick - MAX_HISTORY_TICKS
	if _state_history.has(oldest_tick):
		_state_history.erase(oldest_tick)

## Validates a hit request from a client by rewinding the physics state.
@rpc("any_peer", "call_remote", "reliable")
func request_hit_validation(client_tick: int, ray_origin: Vector3, ray_normal: Vector3) -> void:
	if not multiplayer.is_server():
		return
		
	var sender_id := multiplayer.get_remote_sender_id()
	
	# Check if the requested tick is still in our history buffer
	if not _state_history.has(client_tick):
		push_warning("Client %d hit request rejected: Tick %d too old or invalid." % [sender_id, client_tick])
		return
		
	var historical_state: Dictionary = _state_history[client_tick]
	var present_state := {}
	
	# --- THE REWIND ---
	# Bypassing SceneTree for performance by editing PhysicsServer3D directly
	for rid: RID in historical_state:
		# Backup the present state directly from the PhysicsServer3D
		present_state[rid] = PhysicsServer3D.body_get_state(rid, PhysicsServer3D.BODY_STATE_TRANSFORM)
		# Snap the body back in time to the historical state
		PhysicsServer3D.body_set_state(rid, PhysicsServer3D.BODY_STATE_TRANSFORM, historical_state[rid])
		
	# --- THE VALIDATION ---
	# Query the physics space while it is suspended in the past
	var space_state := get_world_3d().direct_space_state
	var ray_end := ray_origin + (ray_normal * 1000.0) # 1000m max weapon range
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	var result := space_state.intersect_ray(query)
	
	# --- THE RESTORATION ---
	for rid: RID in present_state:
		# Snap the body back to the present
		PhysicsServer3D.body_set_state(rid, PhysicsServer3D.BODY_STATE_TRANSFORM, present_state[rid])
		
	# --- RESOLVE IMPACT ---
	if result:
		var hit_collider: Object = result["collider"]
		if hit_collider.has_method("apply_damage"):
			# Example damage application
			hit_collider.apply_damage(10)
			# Notify the client of a confirmed hit if needed
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — bodies/shapes rewound for hit tests
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — server ray queries after rewind
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — RID PhysicsServer patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
