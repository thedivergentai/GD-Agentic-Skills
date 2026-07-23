# UI Communication

Based on Thief's "light gem" innovation:

```gdscript
class_name StealthHUD
extends Control

@onready var visibility_meter: TextureProgressBar
@onready var sound_meter: TextureProgressBar
@onready var minimap: Control

func _process(_delta: float) -> void:
    visibility_meter.value = player.get_light_level() * 100
    sound_meter.value = player.current_noise_level * 100
```

### 4. Reaction-Delay Window (Meter)
Decoupled detection tracking with a forgiveness period to prevent instant "gotcha" moments.

```gdscript
# detection_meter.gd
func process_vision(is_seeing: bool, delta: float):
    if is_seeing:
        current_awareness += delta
        if current_awareness >= threshold:
            player_detected.emit()
    else:
        # Gradually decay awareness when out of sight
        current_awareness = max(0, current_awareness - delta * 0.5)
```

### 5. Cover-Point Finder (Raycast)
Find and verify valid cover points using Navigation and Physics queries.

```gdscript
# cover_finder.gd
func find_cover(threat_pos: Vector3):
    var map = get_world_3d().get_navigation_map()
    for i in 10:
        # Get a random point on the navmesh
        var p = NavigationServer3D.map_get_random_point(map, 1, false)
        # Verify LOS is broken from the point to the threat
        var query = PhysicsRayQueryParameters3D.create(p + Vector3.UP, threat_pos + Vector3.UP)
        var hit = get_world_3d().direct_space_state.intersect_ray(query)
        if hit: 
            return p # Hit environmental geometry, point is valid cover
    return global_position
```

### 6. Detection Cone Shader (Post-Process)
Highlight detection areas using a screen-space shader for clear player feedback.

```glsl
// vision.gdshader
shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture;
uniform vec2 enemy_pos; // Normalized screen coordinates (0.0-1.0)

void fragment() {
    vec4 base = texture(screen, SCREEN_UV);
    float dist = distance(SCREEN_UV, enemy_pos);
    if (dist < 0.2) {
        // Tint detected area red
        COLOR = mix(base, vec4(1, 0, 0, 1), 0.3);
    } else {
        COLOR = base;
    }
}
```
```

---
