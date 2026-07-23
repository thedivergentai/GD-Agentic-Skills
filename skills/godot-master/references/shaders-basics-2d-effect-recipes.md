# 2D shader effect recipes

Beginner tinting belongs in Official Docs — these are copy-paste starters agents often get wrong.

## First canvas_item tint

```glsl
shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = tex_color * vec4(1.0, 0.5, 0.5, 1.0);
}
```

Attach via ShaderMaterial on Sprite2D.

## Dissolve (tutorial baseline — prefer ALPHA_SCISSOR expert script)

> [!CAUTION]
> Unconditional `discard` breaks depth prepass. For production cutouts use [dissolve_scissor_expert.gdshader](../scripts/shaders_basics_dissolve_scissor_expert.gdshader).

```glsl
shader_type canvas_item;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_texture;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float noise = texture(noise_texture, UV).r;
    if (noise < dissolve_amount) { discard; }
    COLOR = tex_color;
}
```

## Wave distortion

```glsl
shader_type canvas_item;
uniform float wave_speed = 2.0;
uniform float wave_amount = 0.05;

void fragment() {
    vec2 uv = UV;
    uv.x += sin(uv.y * 10.0 + TIME * wave_speed) * wave_amount;
    COLOR = texture(TEXTURE, uv);
}
```

## Outline

```glsl
shader_type canvas_item;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width = 2.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;
    float alpha = col.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a);
    COLOR = mix(outline_color, col, col.a);
    COLOR.a = alpha;
}
```
