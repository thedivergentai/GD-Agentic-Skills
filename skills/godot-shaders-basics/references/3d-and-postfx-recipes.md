# 3D spatial and screen-space recipes

## Basic spatial albedo

```glsl
shader_type spatial;
void fragment() { ALBEDO = vec3(1.0, 0.0, 0.0); }
```

## Toon / cel shading

```glsl
shader_type spatial;
uniform vec3 base_color : source_color = vec3(1.0);
uniform int color_steps = 3;

void light() {
    float NdotL = dot(NORMAL, LIGHT);
    float stepped = floor(NdotL * float(color_steps)) / float(color_steps);
    DIFFUSE_LIGHT = base_color * stepped;
}
```

## Vignette (screen texture)

```glsl
shader_type canvas_item;
uniform float vignette_strength = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float dist = distance(UV, vec2(0.5));
    COLOR = color * (1.0 - dist * vignette_strength);
}
```

## Full-screen quad (Reversed-Z)

Godot 4.3+ — **NEVER** `POSITION = vec4(VERTEX, 1.0)`. Use [screenspace_full_quad.gdshader](../scripts/screenspace_full_quad.gdshader).
