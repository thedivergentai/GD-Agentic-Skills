# sleepy_block.gd
extends RigidBody2D
class_name SleepyBlock

# Interactive Physics Puzzle Sleep State
# Interfaces with low-level body state to force sleep on demand.

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    # Pattern: Optimize interactive puzzles by sleeping when movement is negligible.
    if state.get_linear_velocity().length() < 5.0 and state.get_angular_velocity() < 0.1:
        state.sleeping = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — PhysicsDirectBodyState2D sleep thresholds for settle checks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
