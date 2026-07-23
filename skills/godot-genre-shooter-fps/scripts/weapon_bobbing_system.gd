# weapon_bobbing_system.gd
extends Node3D
class_name WeaponBobbingSystem

# Procedural Weapon Bobbing
# Simulates the realistic movement of holding a gun using sine waves.

@export var bob_frequency := 2.0
@export var bob_amplitude := 0.05
var _time_passed := 0.0

func apply_bobbing(delta: float, is_moving: bool) -> void:
    if is_moving:
        _time_passed += delta
        # Pattern: Procedural offsets for X (sway) and Y (bob).
        var offset_y := sin(_time_passed * bob_frequency * 2.0) * bob_amplitude
        var offset_x := cos(_time_passed * bob_frequency) * bob_amplitude
        transform.origin = Vector3(offset_x, offset_y, 0.0)
    else:
        # Smoothly return to center when idle.
        transform.origin = transform.origin.lerp(Vector3.ZERO, delta * 5.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md - sway/bob layered with look and recoil
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md - optional tween assists for viewmodel settle
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
