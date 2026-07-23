# precision_cost_validator.gd
extends Node

# Precision-Safe Cost Validation
# Accounts for IEEE 754 precision loss when comparing floating-point economy values.
func can_afford(currency: float, cost: float) -> bool:
    # is_equal_approx prevents scenarios where 100.0000001 vs 100.0 causes a failed purchase.
    # Pattern: Exact equality is unreliable; use approx or greater-than threshold.
    return currency > cost or is_equal_approx(currency, cost)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — is_equal_approx purchase guards
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — afford checks before spend
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
