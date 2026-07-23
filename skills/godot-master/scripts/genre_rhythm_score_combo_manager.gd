# score_combo_manager.gd
extends Node
class_name ScoreComboManager

# Functional Reduction for Multipliers
# Manages combo-based scoring with persistent state.

var score := 0
var combo := 0
var max_combo := 0

func add_hit(multiplier: int) -> void:
    combo += 1
    max_combo = max(combo, max_combo)
    
    # Pattern: Scale score by combo milestones.
    var combo_bonus = 1.0 + (floor(combo / 10.0) * 0.1)
    score += int(100 * multiplier * combo_bonus)

func reset_combo() -> void:
    combo = 0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — combo multiplier curves vs difficulty
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — combo/score HUD bindings
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — combo_broken / score_changed owners
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
