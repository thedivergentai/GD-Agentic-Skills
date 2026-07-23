class_name ImpactCamera3D extends Camera3D

@export var decay_rate: float = 5.0
var _current_shake_strength: float = 0.0

func _process(delta: float) -> void:
    if _current_shake_strength > 0.01:
        _current_shake_strength = lerpf(_current_shake_strength, 0.0, decay_rate * delta)
        h_offset = randf_range(-_current_shake_strength, _current_shake_strength)
        v_offset = randf_range(-_current_shake_strength, _current_shake_strength)
    else:
        h_offset = 0.0
        v_offset = 0.0

func _on_shake_requested(intensity: float) -> void:
    _current_shake_strength = max(_current_shake_strength, intensity)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
