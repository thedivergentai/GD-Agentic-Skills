# loot_drop_economy_bridge.gd
# Hooking combat drops to wallet addition
extends Node

# EXPERT NOTE: Use a generic node to listen for "Gold Drops" from enemies 
# to keep the combat system focused only on health/damage.

func _on_enemy_looted(gold_amount: int):
	WalletManager.add_funds("gold", gold_amount)
	print("Looted ", gold_amount, " gold.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — listen for loot events, grant funds
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — bridge node keeps combat decoupled
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
