# wallet_manager_singleton.gd
# Centralized economy state and transactions
extends Node

# EXPERT NOTE: The Wallet should be an Autoload to manage 
# balances across different scenes (Shop vs World).

signal balance_changed(currency_id: String, new_amount: int)
signal transaction_failed(reason: String)

var balances: Dictionary = {} # currency_id -> int

func add_funds(currency_id: String, amount: int):
	var current = balances.get(currency_id, 0)
	balances[currency_id] = current + amount
	balance_changed.emit(currency_id, balances[currency_id])

func spend_funds(currency_id: String, amount: int) -> bool:
	var current = balances.get(currency_id, 0)
	if current >= amount:
		balances[currency_id] = current - amount
		balance_changed.emit(currency_id, balances[currency_id])
		return true
	
	transaction_failed.emit("Insufficient funds")
	return false
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — Wallet Autoload ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — balance_changed signal discipline
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
