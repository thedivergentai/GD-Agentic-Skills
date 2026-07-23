class_name CrowdAgent3D extends CharacterBody3D
## A completely node-less avoidance agent using the NavigationServer3D API.

@export var max_speed: float = 4.0
var _server_agent_rid: RID

func _ready() -> void:
    # Create the agent on the server and assign it to the default map.
    _server_agent_rid = NavigationServer3D.agent_create()
    NavigationServer3D.agent_set_map(_server_agent_rid, get_world_3d().get_navigation_map())
    
    # Enable avoidance and set physical dimensions.
    NavigationServer3D.agent_set_avoidance_enabled(_server_agent_rid, true)
    NavigationServer3D.agent_set_radius(_server_agent_rid, 0.5)
    NavigationServer3D.agent_set_max_speed(_server_agent_rid, max_speed)
    
    # Crowd Tuning: Configure neighbor detection.
    NavigationServer3D.agent_set_neighbor_distance(_server_agent_rid, 50.0)
    NavigationServer3D.agent_set_max_neighbors(_server_agent_rid, 20)
    
    # Time horizons: How far ahead to predict agent/obstacle collisions.
    NavigationServer3D.agent_set_time_horizon_agents(_server_agent_rid, 1.0)
    NavigationServer3D.agent_set_time_horizon_obstacles(_server_agent_rid, 0.5)
    
    # Bind callback to safely receive computed velocity.
    NavigationServer3D.agent_set_avoidance_callback(_server_agent_rid, _on_velocity_computed)

func _physics_process(_delta: float) -> void:
    # Determine desired velocity towards target.
    var preferred_velocity: Vector3 = Vector3.FORWARD * max_speed 
    NavigationServer3D.agent_set_velocity(_server_agent_rid, preferred_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
    velocity = safe_velocity
    move_and_slide()

func _exit_tree() -> void:
    if _server_agent_rid.is_valid():
        NavigationServer3D.free_rid(_server_agent_rid)
