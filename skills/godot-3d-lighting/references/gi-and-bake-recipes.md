# Gi And Bake Recipes

## Global Illumination: VoxelGI vs SDFGI

### Decision Matrix

| Feature | VoxelGI | SDFGI |
|---------|---------|-------|
| Setup | Manual bounds per room | Automatic, scene-wide |
| Dynamic objects | Fully supported | Partially supported |
| Performance | Moderate | Higher cost |
| Use case | Indoor, small-medium scenes | Large outdoor scenes |
| Godot version | 4.0+ | 4.0+ |

### VoxelGI Setup

```gdscript
# room_gi.gd - Place one VoxelGI per room/area
extends VoxelGI

func _ready() -> void:
    # Tightly fit the room
    size = Vector3(20, 10, 20)
    
    # Quality settings
    subdiv = VoxelGI.SUBDIV_128  # Higher = better quality, slower
    
    # Bake GI data
    bake()
```

### SDFGI Setup

```gdscript
# world_environment.gd
extends WorldEnvironment

func _ready() -> void:
    var env := environment
    
    # Enable SDFGI
    env.sdfgi_enabled = true
    env.sdfgi_use_occlusion = true
    env.sdfgi_read_sky_light = true
    
    # Cascades (auto-scale based on camera)
    env.sdfgi_min_cell_size = 0.2  # Detail level
    env.sdfgi_max_distance = 200.0
```

---

## LightmapGI (Baked Static Lighting)

### When to Use

- Static architecture (buildings, dungeons)
- Mobile/low-end targets
- No  dynamic geometry

### Setup

```gdscript
# Scene structure:
# - LightmapGI node
# - StaticBody3D meshes with GeometryInstance3D.gi_mode = STATIC

# lightmap_baker.gd
extends LightmapGI

func _ready() -> void:
    # Quality settings
    quality = LightmapGI.BAKE_QUALITY_HIGH
    bounces = 3  # Indirect light bounces
    
    # Bake (editor only, not runtime)
    # Click "Bake Lightmaps" button in editor
```

---

## ReflectionProbe

For localized reflections (mirrors, shiny floors):

```gdscript
# reflection_probe.gd
extends ReflectionProbe

func _ready() -> void:
    # Capture area
    size = Vector3(10, 5, 10)
    
    # Quality
    resolution = ReflectionProbe.RESOLUTION_512
    
    # Update mode
    update_mode = ReflectionProbe.UPDATE_ONCE  # Bake once
    # or UPDATE_ALWAYS for dynamic reflections (expensive)
```

---
