# fog_claus_intensifier.gd
extends Node

# Dynamically Adjusting Volumetric Fog (Dread Atmosphere)
# Increases the claustrophobia effect by manipulating environment density in real-time.
func intensify_fog(env: Environment, target_density: float = 0.15) -> void:
    # Set this to the lowest base density you want globally.
    var current_density := env.volumetric_fog_density
    var tween := create_tween().set_trans(Tween.TRANS_SINE)
    
    # Smoothly increase density over time to signal increasing danger or psychological shifts.
    tween.tween_property(env, "volumetric_fog_density", current_density + target_density, 5.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_environment.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — lights required for visible volumetric fog
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — density ramps during dread buildup
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — Camera3D.environment overrides
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
