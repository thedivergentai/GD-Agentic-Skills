# shop_system_logic.gd
# Orchestrating buys and sells
extends Node

# EXPERT NOTE: Logic should be decoupled from UI. 
# This node handles the actual exchange of resources.

func buy_item(shop_item: ShopItem) -> bool:
	if shop_item.current_stock == 0:
		return false
		
	if WalletManager.spend_funds(shop_item.currency_id, shop_item.cost):
		if shop_item.current_stock > 0:
			shop_item.current_stock -= 1
		
		# Assumes InventoryManager exists
		InventoryManager.add_item(shop_item.item)
		return true
		
	return false

func sell_item(item: InventoryItem, price: int):
	if InventoryManager.remove_item(item):
		WalletManager.add_funds("gold", price)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — buy/sell inventory exchange
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — shop UI calls logic, not wallet
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
