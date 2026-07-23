# Expert advanced shader patterns

## Deferred fog volume

```glsl
shader_type fog;
uniform float base_density : hint_range(0.0, 10.0) = 1.0;
uniform vec3 edge_color : source_color = vec3(0.1, 0.5, 0.8);

void fog() {
    float distance_factor = clamp(-SDF, 0.0, 1.0);
    float edge_fade = pow(distance_factor, 2.0);
    DENSITY = base_density * edge_fade;
    ALBEDO = edge_color;
}
```

## Compute particle sim (RenderingDevice overview)

See Official Docs: Compute shaders. Pattern: local `RenderingDevice`, storage buffer, `compute_pipeline_create`, dispatch workgroups — for boids/fluids beyond fragment shaders.

## Shader debug visualizer

Depth / normal / UV modes on a full-screen spatial quad using `hint_depth_texture` and `hint_normal_roughness_texture`. Production depth work: [depth_world_reconstruction.gdshader](../scripts/depth_world_reconstruction.gdshader).

## VisualShaderNodeCustom

Extend `VisualShaderNodeCustom` in GDScript to expose reusable math nodes in the visual editor (`_get_code` returns GLSL snippet).

## Shader precompilation warmup

During loading: instantiate heavy scenes in front of camera, `await RenderingServer.frame_post_draw`, then `queue_free()` children — forces pipeline cache before gameplay.
