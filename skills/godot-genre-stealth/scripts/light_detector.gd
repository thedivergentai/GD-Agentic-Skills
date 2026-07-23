# skills/genre-stealth/scripts/light_detector.gd
extends Node3D

## Light Detector (Expert Pattern)
## Estimates how lit the player is by sampling light sources.
## More performance-friendly than rendering viewport textures.

class_name LightDetector

@export var body_mesh: MeshInstance3D # To get bounds
@export var active: bool = True

func get_light_level() -> float:
    if not active: return 0.0
    
    var total_light = 0.0
    var ambient = get_world_3d().environment.ambient_light_color.v if get_world_3d().environment else 0.0
    total_light += ambient
    
    # Find nearby lights
    # In a real system, use an Area3D to track lights entering/exiting range
    # For this snippet, we iterate group "lights" (Optimization warning: Don't do this every frame for 100 lights)
    
    for light in get_tree().get_nodes_in_group("lights"):
        if light is OmniLight3D:
            var dist_sq = global_position.distance_squared_to(light.global_position)
            var range_sq = light.omni_range * light.omni_range
            if dist_sq < range_sq:
                # Check occlusion
                if _is_occluded(light.global_position):
                     continue
                     
                var attenuation = 1.0 - (dist_sq / range_sq) # Simplified
                total_light += light.light_energy * attenuation
                
    return clamp(total_light, 0.0, 1.0)

func _is_occluded(light_pos: Vector3) -> bool:
    var query = PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, light_pos)
    var result = get_world_3d().direct_space_state.intersect_ray(query)
    # If hit something that isn't the light (lights don't have collision usually)
    return not result.is_empty()

## EXPERT USAGE:
## Add lights to group "lights". 
## Call get_light_level() from Stealth AI.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — OmniLight3D energy/range for light-gem sampling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — occluded light rays to sample points
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — ambient vs direct exposure balance
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md
# =============================================================================
