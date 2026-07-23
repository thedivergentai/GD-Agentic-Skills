# Economy Elite Patterns (load on demand)

> **MANDATORY** for GPM analytics, dynamic item valuation, and shop/loot pedagogy beyond wallet + transaction golden path.

## Wallet + shop tutorials (moved to scripts)

| Concern | Script |
|---------|--------|
| Balances / signals | [wallet_manager_singleton.gd](../scripts/wallet_manager_singleton.gd) |
| Validated spend/grant | [transaction_manager.gd](../scripts/transaction_manager.gd) |
| Shop stock + spread | [shop_item_data.gd](../scripts/shop_item_data.gd), [shop_system_logic.gd](../scripts/shop_system_logic.gd) |
| Weighted loot | [loot_table_weighted.gd](../scripts/loot_table_weighted.gd) |
| Barter | [trade_contract_resource.gd](../scripts/trade_contract_resource.gd) |

## Buy/sell spread (WHY)

> **CAUTION:** `sell_price == buy_price` enables infinite arbitrage. Typical sell = 50% of buy unless design says otherwise.

```gdscript
func calculate_sell_price(buy_price: int, markup: float = 0.5) -> int:
	return int(buy_price * markup)
```

## Dynamic pricing

[dynamic_price_modifier.gd](../scripts/dynamic_price_modifier.gd) — demand multiplier on base price.

## GPM analytics

[economy_logger.gd](../scripts/economy_logger.gd) — custom `Logger` intercepting `[ECON]:amount` lines; computes gold-per-minute for inflation detection.

> **NEVER** `print()` inside `Logger._log_message` — recursion crash.

## Item value estimator

[item_value_estimator.gd](../scripts/item_value_estimator.gd) — rarity enum drives merchant buy/sell curves; always sell below buy.

## Multi-item barter

```gdscript
class_name TradeOffer extends Resource

@export var items_required: Array[Resource] = []
@export var items_provided: Array[Resource] = []

func can_afford(inventory: Node) -> bool:
	for item in items_required:
		if not inventory.has_method(&"has_item") or not inventory.call(&"has_item", item):
			return false
	return true
```

Production: [trade_contract_resource.gd](../scripts/trade_contract_resource.gd).

## Currency representation reminder

| Type | Store as |
|------|----------|
| Soft currency | `int` smallest unit |
| Premium / idle huge counts | BigInt or scaled int — see SKILL decision tree |
| Multiplayer | Server-authoritative ints |

**NEVER** use `float` for exact coin counts (`0.1 + 0.2` drift).
