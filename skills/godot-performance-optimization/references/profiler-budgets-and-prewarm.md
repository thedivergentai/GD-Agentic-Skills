# Profiler budgets and pre-warm

> AStar/path time-slicing, shader pre-warm, VRAM compression tables. Prefer `navigation_agent_optimization.gd` and `object_pool_system.gd` in hot paths.

## Common Optimizations

### Object Pooling

```gdscript
var bullet_pool: Array[Node] = []

func get_bullet() -> Node:
    if bullet_pool.is_empty():
        return Bullet.new()
    return bullet_pool.pop_back()

func return_bullet(bullet: Node) -> void:
    bullet.hide()
    bullet_pool.append(bullet)
```

### Visibility Notifier

```gdscript

### AStar-Throttler (Pathfinding Budget)
Spreading pathfinding costs over multiple frames to prevent frame-time spikes.
- **Implementation**:
    ```gdscript
    var _query_queue: Array[Callable] = []
    const TIME_BUDGET_USEC := 1000 # 1ms budget

    func _process(_delta):
        var start_time := Time.get_ticks_usec()
        while not _query_queue.is_empty() and (Time.get_ticks_usec() - start_time) < TIME_BUDGET_USEC:
            var query = _query_queue.pop_front()
            query.call()
    ```

### Shader-Preloading (Zero-Hitch Strategy)
- **Forward+ / Mobile**: Godot 4.4+ uses **Ubershaders** for automatic precompilation. Ensure scenes are instantiated at least once (even if invisible) at load-time to trigger pipeline detection [19].
- **Compatibility (OpenGL)**: Place a hidden `Camera3D` looking at a small area containing every unique mesh and material in your project for 1 frame during the loading screen [20].

### VRAM Compression Guide
- **S3TC (Desktop)**: Best for high-quality textures on Windows/Linux/macOS.
- **BPTC (Desktop)**: Superior quality for HDR and normal maps; slightly higher VRAM usage.
- **ETC2 (Mobile)**: The standard for Android/iOS; ensure textures are opaque where possible for maximum compatibility [13].
