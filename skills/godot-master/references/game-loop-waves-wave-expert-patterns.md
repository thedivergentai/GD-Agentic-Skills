# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Expert Wave Patterns

### 1. Occlusion Culling for Swarms
To optimize performance with hundreds of enemies, enable **Occlusion Culling**.
- **Setup**: Add an `OccluderInstance3D` to your arena and bake it.
- **Result**: Enemies completely hidden behind walls/pillars won't be processed by the GPU, significantly boosting FPS.

### 2. Wave UI Architecture
Decouple your wave data from the UI using a `CanvasLayer` and signals.
- **Wave Counter**: Display current/total waves.
- **Health Bars**: Use a `TextureProgressBar` on a `CanvasLayer` for bosses, or `Sprite3D` with a viewport texture for individual enemy health bars.
