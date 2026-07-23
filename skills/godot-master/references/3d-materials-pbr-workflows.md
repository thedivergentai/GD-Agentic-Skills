# Pbr Workflows

## Advanced Features

### Emission (Glowing Materials)

```gdscript
mat.emission_enabled = true
mat.emission = Color(1.0, 0.5, 0.0)  # Orange glow
mat.emission_energy_multiplier = 2.0  # Brightness (HDR)
mat.emission_texture = load("res://lava_emission.png")

# Animated emission
func _process(delta: float) -> void:
    mat.emission_energy_multiplier = 1.0 + sin(Time.get_ticks_msec() * 0.005) * 0.5
```

### Rim Lighting (Fresnel)

```gdscript
mat.rim_enabled = true
mat.rim = 1.0  # Intensity
mat.rim_tint = 0.5  # How much albedo affects rim color
```

### Clearcoat (Car Paint)

```gdscript
mat.clearcoat_enabled = true
mat.clearcoat = 1.0  # Layer strength
mat.clearcoat_roughness = 0.1  # Glossy top layer
```

### Anisotropy (Brushed Metal)

```gdscript
mat.anisotropy_enabled = true
mat.anisotropy = 1.0  # Directional highlights
mat.anisotropy_flowmap = load("res://brushed_flow.png")
```

---

## Common Material Presets

```gdscript
# Glass
func create_glass() -> StandardMaterial3D:
    var mat := StandardMaterial3D.new()
    mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    mat.albedo_color = Color(1, 1, 1, 0.2)
    mat.metallic = 0.0
    mat.roughness = 0.0
    mat.refraction_enabled = true
    mat.refraction_scale = 0.05
    return mat

# Gold
func create_gold() -> StandardMaterial3D:
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(1.0, 0.85, 0.3)
    mat.metallic = 1.0
    mat.roughness = 0.3
    return mat
```



---
