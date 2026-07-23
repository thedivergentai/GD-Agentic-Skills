# flashlight_flicker.gd
extends Node

# Procedural Flashlight Flicker (Light/Dark Atmosphere)
# Uses Tween for lightweight parameter manipulation instead of bulky AnimationPlayers.
var _flicker_tween: Tween

func trigger_flashlight_flicker(light: SpotLight3D) -> void:
    # Kill existing tween to avoid stacking flickers.
    if _flicker_tween:
        _flicker_tween.kill()
        
    _flicker_tween = create_tween().set_loops(4)
    
    # Smoothly animates the light energy property to simulate failing batteries or interference.
    # Pattern: Buildup of darkness -> Rapid flash back to full.
    _flicker_tween.tween_property(light, "light_energy", 0.0, 0.05)
    _flicker_tween.tween_property(light, "light_energy", 2.5, 0.1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/classes/class_spotlight3d.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — SpotLight3D energy and shadow cost
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — procedural flicker without AnimationPlayer
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — flashlight follows player look
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
