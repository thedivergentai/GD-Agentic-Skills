# SDFGI Quality and Probe Control
extends WorldEnvironment

## SDFGI is powerful but expensive. This script manages probe cell size
## based on the current graphics preset.

func set_sdfgi_preset(is_high_end: bool) -> void:
    var env = environment
    env.sdfgi_enabled = true
    
    if is_high_end:
        env.sdfgi_min_cell_size = 0.2
        env.sdfgi_use_occlusion = true
        env.sdfgi_read_sky_light = true
    else:
        env.sdfgi_min_cell_size = 0.8 # Larger cells = lower CPU cost
        env.sdfgi_use_occlusion = false
        env.sdfgi_read_sky_light = false
        
    # Architecture Tip: SDFGI probes are updated over multiple frames.
    # Rapid camera movement can cause 'ghosting' at small cell sizes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_sdfgi.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_environment.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — half-res / ray-count knobs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — SDFGI is Forward+ only
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — renderer must be Forward+
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
