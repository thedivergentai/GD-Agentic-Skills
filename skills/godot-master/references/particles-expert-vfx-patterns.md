# Expert VFX patterns

> Collision sub-emitters, custom particle shaders, and VFX pooling. Common explosion/smoke material UI → Official Docs.

## Collision sub-emitters (GPU audio sync limits)

GPU particles do not emit CPU signals for individual collisions. To sync visual impacts, use the Sub-Emitter system to spawn secondary effects (sparks, dust) on contact.

```gdscript
func setup_collision_vfx(primary: GPUParticles3D, impact: GPUParticles3D) -> void:
    # 1. Assign impact system as sub-emitter
    primary.sub_emitter = primary.get_path_to(impact)
    
    var mat := primary.process_material as ParticleProcessMaterial
    if mat:
        # 2. Enable collision and set trigger mode
        mat.collision_mode = ParticleProcessMaterial.COLLISION_RIGID
        mat.sub_emitter_mode = ParticleProcessMaterial.SUB_EMITTER_AT_COLLISION
        mat.sub_emitter_amount_at_collision = 1 # Spawn 1 spark per impact
```

> [!IMPORTANT]
> Since the CPU cannot track individual GPU collisions, sync audio by playing a randomized looping "impact" sound while the primary emitter is active, or use `CPUParticles` for precise RayCast-driven audio timing.

---

## Fluid / swarm particle shaders

For high-performance liquid or swarm effects, bypass `ParticleProcessMaterial` and use a custom `particles` shader with state persistence.

```glsl
shader_type particles;
// 'keep_data' allows the shader to remember state between frames
render_mode keep_data;

void start() {
    if (RESTART) {
        // Initialize position and custom fluid density
        TRANSFORM[3].xyz = EMISSION_TRANSFORM[3].xyz;
        CUSTOM.x = 1.0; 
    }
}

void process() {
    // Apply gravity and attractor forces
    VELOCITY += ATTRACTOR_FORCE * DELTA;
    
    // Built-in GPU collision handling
    if (COLLIDED) {
        VELOCITY = reflect(VELOCITY, COLLISION_NORMAL) * 0.5;
        TRANSFORM[3].xyz += COLLISION_NORMAL * COLLISION_DEPTH;
    }
}
```

---

## VFX pool manager

Prevent frame-spikes from frequent `instantiate()` and `queue_free()` calls by pooling and reusing one-shot particle systems.

```gdscript
class_name VFXPool extends Node

@export var vfx_scene: PackedScene
var pool: Array[GPUParticles3D] = []

func _ready() -> void:
    for i in 20:
        var inst := vfx_scene.instantiate() as GPUParticles3D
        add_child(inst)
        inst.emitting = false
        inst.finished.connect(func(): pool.append(inst))
        pool.append(inst)

func spawn(pos: Vector3) -> void:
    if pool.is_empty(): return
    var vfx = pool.pop_back()
    vfx.global_position = pos
    # Use restart() to avoid async GPU state delays
    vfx.restart()
```
