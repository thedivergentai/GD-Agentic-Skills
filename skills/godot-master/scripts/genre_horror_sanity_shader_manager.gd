# sanity_shader_manager.gd
extends Node

# Shader Uniform Manipulation for Hallucinations (Psychological Horror)
# Passes runtime sanity values directly into mesh instances without material duplication.
func update_sanity_visuals(mesh: GeometryInstance3D, current_sanity: float) -> void:
    # set_instance_shader_parameter is highly optimized and avoids per-mesh material copies.
    # Note: Requires the shader to have a 'hallucination_intensity' uniform.
    var intensity = clamp(1.0 - current_sanity, 0.0, 1.0)
    mesh.set_instance_shader_parameter(&"hallucination_intensity", intensity)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — instance uniforms for per-mesh distortion
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — material overrides for sanity FX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — screen effects couple to shake
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
