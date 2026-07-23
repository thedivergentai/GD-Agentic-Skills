# lightweight_upgrade_resource.gd
extends RefCounted
class_name ClickerUpgradeResource

# Lightweight RefCounted Data Structures
# Avoids the Node-tree overhead for non-visual upgrade logic.
var level: int = 0
var multiplier: float = 1.15
var base_cost: float = 10.0

func get_next_cost() -> float:
    # Standard idle scaling formula: cost * (growth ^ level)
    return base_cost * pow(multiplier, level)

func purchase() -> void:
    level += 1
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — upgrade data without Node trees
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — prestige/upgrade curve careers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
