# XR expert patterns (extended)

> OpenXR bootstrap, comfort settings, motion controls — extended samples beyond SKILL.md comfort tree.

## OpenXR bootstrap

```gdscript
# Enable XR
func _ready() -> void:
    var xr_interface := XRServer.find_interface("OpenXR")
    if xr_interface and xr_interface.initialize():
        get_viewport().use_xr = true
```

## Comfort Settings

- **Vignetting** during movement
- **Snap turning** (30°/45° increments)
- **Teleport locomotion** option
- **Seated mode** support

## Motion Controls

```gdscript

## Performance

- **90 FPS minimum** - Critical for comfort
- **Low latency** - < 20ms motion-to-photon
- **Foveated rendering** if supported
