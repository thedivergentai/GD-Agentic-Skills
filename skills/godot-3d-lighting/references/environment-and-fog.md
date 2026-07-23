# Environment And Fog

## Environment & Sky

### HDR Skybox

```gdscript
# world_env.gd
extends WorldEnvironment

func _ready() -> void:
    var env := environment
    
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_material := PanoramaSkyMaterial.new()
    sky_material.panorama = load("res://hdri/sky.hdr")
    sky.sky_material = sky_material
    env.sky = sky
    
    # Sky contribution to GI
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_sky_contribution = 1.0
```

### Volumetric Fog

```gdscript
extends WorldEnvironment

func _ready() -> void:
    var env := environment
    
    env.volumetric_fog_enabled = true
    env.volumetric_fog_density = 0.01
    env.volumetric_fog_albedo = Color(0.9, 0.9, 1.0)  # Blueish
    env.volumetric_fog_emission = Color.BLACK
```

---
