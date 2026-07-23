# screenspace_hex_pixelate.gdshader
# Advanced post-processing hex pixelation [13]
shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 norm_size = size * SCREEN_PIXEL_SIZE;
	bool less_than_half = mod(SCREEN_UV.y / 2.0, norm_size.y) / norm_size.y < 0.5;
	vec2 uv = SCREEN_UV + vec2(norm_size.x * 0.5 * float(less_than_half), 0.0);
	vec2 center_uv = floor(uv / norm_size) * norm_size;
	vec2 norm_uv = mod(uv, norm_size) / norm_size;
	
	center_uv += mix(vec2(0.0, 0.0), 
					 mix(mix(vec2(norm_size.x, -norm_size.y), vec2(0.0, -norm_size.y), float(norm_uv.x < 0.5)), 
						 mix(vec2(0.0, -norm_size.y), vec2(-norm_size.x, -norm_size.y), float(norm_uv.x < 0.5)), 
						 float(less_than_half)), 
					 float(norm_uv.y < 0.3333333) * float(norm_uv.y / 0.3333333 < (abs(norm_uv.x - 0.5) * 2.0)));
	
	COLOR = textureLod(screen_texture, center_uv, 0.0);
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/custom_postprocessing.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/using_viewport_as_texture.html
# Related skills:
# - ../godot-camera-systems/SKILL.md — viewport/camera setup feeding screen textures
# - ../godot-2d-animation/SKILL.md — stylized 2D presentation layers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
