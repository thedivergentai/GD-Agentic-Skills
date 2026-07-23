# Uniforms and built-in variables

## Uniform hints

```glsl
uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 tint_color : source_color = vec4(1.0);
uniform sampler2D noise_texture;
```

Runtime: `material.set_shader_parameter("intensity", 0.8)`

## canvas_item built-ins

- `UV`, `COLOR`, `TEXTURE`, `TIME`, `SCREEN_UV`

## spatial built-ins

- `ALBEDO`, `NORMAL`, `ROUGHNESS`, `METALLIC`

## WHY uniforms beat hardcoding

```glsl
// GOOD — tweakable in inspector
uniform float speed = 1.0;
void fragment() { COLOR.r = sin(TIME * speed); }

// BAD — requires shader recompile to tune
void fragment() { COLOR.r = sin(TIME * 2.5); }
```

Move invariant math to `vertex()`; pass via `varying`.
