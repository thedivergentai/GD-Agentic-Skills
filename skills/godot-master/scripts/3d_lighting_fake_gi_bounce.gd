# Fake GI Bounce for Mobile
extends Node3D

## Real-time GI (SDFGI/VoxelGI) is too heavy for mobile GPUs.
## This script fakes 'floor bounce' by placing non-shadowed lights.

func setup_fake_bounce(main_light: DirectionalLight3D) -> void:
    var bounce_light = DirectionalLight3D.new()
    add_child(bounce_light)
    
    # Rotate 180 degrees to point "up" from the ground
    bounce_light.rotation = main_light.rotation + Vector3(PI, 0, 0)
    
    # Crucial performance settings
    bounce_light.shadow_enabled = false
    bounce_light.light_energy = 0.2 # Subdued bounce intensity
    bounce_light.light_specular = 0.0 # Diffuse only
    bounce_light.light_color = Color(0.8, 0.7, 0.5) # Ground-tinted hue
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/faking_global_illumination.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/classes/class_directionallight3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — Mobile-GI fill lights
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid real GI cost
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — floor albedo drives bounce color
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
