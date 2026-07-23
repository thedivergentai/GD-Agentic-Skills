# fast_projectile_ccd.gd
extends RigidBody2D
class_name FastProjectileCCD

# Continuous Collision Detection (CCD) for High-Speed Sprites
# Prevents "tunneling" through thin geometry.

func _ready() -> void:
    # Pattern: Use ray-casting CD for extremely fast, small bullets/sprites.
    continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
    max_contacts_reported = 1
    contact_monitor = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — CCD_MODE_CAST_RAY anti-tunneling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — fast hazard/projectile hits
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
