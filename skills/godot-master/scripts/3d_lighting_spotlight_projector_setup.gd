# SpotLight3D Projector Setup
extends SpotLight3D

## Using 'Cookies' or Projector Textures to create 
## high-detail lighting patterns (Flashlight glass, window grates).

func setup_projector(texture_path: String) -> void:
	var tex = load(texture_path)
	if tex:
		light_projector = tex
		
	# Architecture Tip: Projectors can be used to fake complex 
	# shadows without the cost of high-res cascade bakes.
	spot_angle = 45.0
	spot_range = 10.0
	shadow_enabled = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/classes/class_spotlight3d.html
# - https://docs.godotengine.org/en/stable/classes/class_light3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — projector cookie textures
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — custom gobo patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md — flashlight projector storytelling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
