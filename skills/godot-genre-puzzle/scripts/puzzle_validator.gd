# puzzle_validator.gd
extends Node
class_name PuzzleValidator

# Array Reduction for Victory Conditions
# Validates completion using optimized functional reduction lambdas.

func check_all_resolved(objectives: Array) -> bool:
    # Pattern: Use Godot 4's functional reduction for concise win checking.
    var completed: int = objectives.reduce(
        func(count, next): return count + 1 if next.get("is_resolved") else count, 0
    )
    return completed == objectives.size()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — emit completion once when reduce succeeds
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — batch-validate generated boards for solvability
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
