# weapon_spread_calc.gd
extends RefCounted
class_name WeaponSpreadCalc

# Normal Distribution Bullet Spread
# Bullets cluster near the crosshair using Gaussian distribution.

static func calculate_spread(forward: Vector3, spread_degrees: float) -> Vector3:
    # Pattern: randfn() clusters around 0.0 for more realistic clustering.
    var dev_x := deg_to_rad(randfn(0.0, spread_degrees))
    var dev_y := deg_to_rad(randfn(0.0, spread_degrees))
    
    var spread_basis := Basis()
    spread_basis = spread_basis.rotated(Vector3.UP, dev_x)
    spread_basis = spread_basis.rotated(Vector3.RIGHT, dev_y)
    
    return spread_basis * forward
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md - bloom vs accuracy win-rate bands
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md - spread direction into damage queries
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
