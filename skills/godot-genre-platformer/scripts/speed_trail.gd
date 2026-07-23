class_name SpeedTrail extends GPUParticles3D

func toggle_trail(active: bool) -> void:
    emitting = active
    trail_enabled = true
    trail_lifetime = 0.5
    # Configure via shader or process_material for color fading
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
