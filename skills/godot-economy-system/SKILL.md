---
name: godot-economy-system
description: "Expert patterns for game economies including currency management (multi-currency, wallet system), shop systems (buy/sell prices, stock limits), dynamic pricing (supply/demand), loot tables (weighted drops, rarity tiers), and economic balance (inflation control, currency sinks). Use for RPGs, trading games, or resource management systems. Trigger keywords: EconomyManager, currency, shop_item, loot_table, dynamic_pricing, buy_sell_spread, currency_sink, inflation, item_rarity."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Economy System

Expert guidance for designing balanced game economies with currency, shops, and loot.

## Available Scripts

### [currency_resource.gd](scripts/currency_resource.gd)
Specialized data container for defining distinct denominations (Gold, Gems, XP) with UI metadata.

### [wallet_manager_singleton.gd](scripts/wallet_manager_singleton.gd)
Centralized AutoLoad orchestrator for managing balances and processing secure transactions.

### [shop_item_data.gd](scripts/shop_item_data.gd)
Resource-based definition for purchasables, including pricing, currency types, and stock limits.

### [shop_system_logic.gd](scripts/shop_system_logic.gd)
Decoupled logic for handling buy/sell exchanges between the Wallet and Inventory systems.

### [dynamic_price_modifier.gd](scripts/dynamic_price_modifier.gd)
Injection pattern for applying temporary discounts or markups based on world state (e.g. Sales).

### [currency_label_sync.gd](scripts/currency_label_sync.gd)
Reactive UI hook for automatically updating currency displays when balances change.

### [loot_drop_economy_bridge.gd](scripts/loot_drop_economy_bridge.gd)
Bridge node for capturing loot events and adding funds to the player's wallet.

### [economy_persistence_handler.gd](scripts/economy_persistence_handler.gd)
Expert logic for serializing financial states into secure, loadable dictionaries.

### [currency_pickup_effect.gd](scripts/currency_pickup_effect.gd)
Visual feedback controller that triggers particles or animations upon financial gain.

### [trade_contract_resource.gd](scripts/trade_contract_resource.gd)
Advanced barter system definition for multi-item "Quid Pro Quo" transactions.

## NEVER Do in Economy Systems

- **NEVER use `int` for large-scale premium economies** — Standard 32-bit integers cap at 2.1 billion. For massive quantities, use `float` or a custom `BigInt` structure [12].
- **NEVER forget to implement a Buy/Sell price spread** — Allowing players to sell items for the same price they bought them creates infinite money exploits [13].
- **NEVER skip "Currency Sinks"** — Without mandatory costs (repairs, taxes, consumables), the game economy will suffer from hyper-inflation [14].
- **NEVER perform currency validation only on the client** — In multiplayer or persistent games, the server MUST be the source of truth for all financial transactions [15].
- **NEVER hardcode loot drop percentages inside scripts** — Changing drop rates should not require a recompile. Use Resources or outside data files for easy balancing [16].
- **NEVER allow negative balances via underflow** — Always check `if current >= amount` BEFORE subtracting. Negative gold can break logic and save files.
- **NEVER modify the wallet balance directly from the UI** — The UI should only request a transaction. The `WalletManager` should decide if it's valid and update the state.
- **NEVER use floating point math for exact currency counts** — `0.1 + 0.2` might equal `0.30000000000000004`, leading to discrepancies. Use `int` for cents/smallest units.
- **NEVER ignore "Transaction Logs" in serious RPGs** — If money disappears, you need a history of events to debug whether it was a bug or a legitimate game event.
- **NEVER give rewards without checking "Max Limit"** — If a player is capped at 999,999 gold, adding 1,000 should result in 999,999, not a wrapped negative number.

---

## Currency Manager

```gdscript
# economy_manager.gd (AutoLoad)
extends Node

signal currency_changed(old_amount: int, new_amount: int)

var gold: int = 0

func add_currency(amount: int) -> void:
    var old := gold
    gold += amount
    currency_changed.emit(old, gold)

func spend_currency(amount: int) -> bool:
    if gold < amount:
        return false
    
    var old := gold
    gold -= amount
    currency_changed.emit(old, gold)
    return true

func has_currency(amount: int) -> bool:
    return gold >= amount
```

## Shop System

```gdscript
# shop_item.gd
class_name ShopItem
extends Resource

@export var item: Item
@export var buy_price: int
@export var sell_price: int
@export var stock: int = -1  # -1 = infinite

func can_buy() -> bool:
    return stock != 0
```

```gdscript
# shop.gd
class_name Shop
extends Resource

@export var shop_name: String
@export var items: Array[ShopItem] = []

func buy_item(shop_item: ShopItem, inventory: Inventory) -> bool:
    if not shop_item.can_buy():
        return false
    
    if not EconomyManager.has_currency(shop_item.buy_price):
        return false
    
    if not EconomyManager.spend_currency(shop_item.buy_price):
        return false
    
    inventory.add_item(shop_item.item, 1)
    
    if shop_item.stock > 0:
        shop_item.stock -= 1
    
    return true

func sell_item(item: Item, inventory: Inventory) -> bool:
    # Find matching shop item for sell price
    var shop_item := get_shop_item_for(item)
    if not shop_item:
        return false
    
    if not inventory.has_item(item, 1):
        return false
    
    inventory.remove_item(item, 1)
    EconomyManager.add_currency(shop_item.sell_price)
    return true

func get_shop_item_for(item: Item) -> ShopItem:
    for shop_item in items:
        if shop_item.item == item:
            return shop_item
    return null
```

## Pricing Formula

```gdscript
func calculate_sell_price(buy_price: int, markup: float = 0.5) -> int:
    # Sell for 50% of buy price
    return int(buy_price * markup)

func calculate_dynamic_price(base_price: int, demand: float) -> int:
    # Price increases with demand
    return int(base_price * (1.0 + demand))
```

## Loot Tables

```gdscript
# loot_table.gd
class_name LootTable
extends Resource

@export var drops: Array[LootDrop] = []

func roll_loot() -> Array[Item]:
    var items: Array[Item] = []
    
    for drop in drops:
        if randf() < drop.chance:
            items.append(drop.item)
    
    return items
```

```gdscript
# loot_drop.gd
class_name LootDrop
extends Resource

@export var item: Item
@export var chance: float = 0.5
@export var min_amount: int = 1
@export var max_amount: int = 1
```

## Best Practices

1. **Balance** - Test economy carefully
2. **Sinks** - Provide money sinks (repairs, etc.)
3. **Inflation** - Control money generation

---

## Elite Godot 4.x Patterns

### 1. Multi-Item Barter System
Use `Resource` arrays to define complex trade offers. This allows designers to visually configure "Quid Pro Quo" transactions without script modifications.

```gdscript
# trade_offer.gd
class_name TradeOffer extends Resource

@export var items_required: Array[Item] = []
@export var items_provided: Array[Item] = []

func can_afford(inventory: Inventory) -> bool:
    for item in items_required:
        if not inventory.has_item(item): return false
    return true
```

### 2. Economic Analytics (GPM Tracking)
Implement a custom `Logger` to intercept economy events and calculate metrics like Gold-Per-Minute (GPM) using the `Time` singleton.

```gdscript
# economy_logger.gd
class_name EconomyLogger extends Logger

var _gold_earned := 0
var _start_time := Time.get_ticks_msec()

func _log_message(msg: String, is_error: bool) -> void:
    if not is_error and msg.begins_with("[ECON]"):
        _gold_earned += msg.split(":")[1].to_int()
        _log_gpm()

func _log_gpm() -> void:
    var mins := (Time.get_ticks_msec() - _start_time) / 60000.0
    var gpm := _gold_earned / max(mins, 0.01)
    # Output to analytics dashboard or file
```

### 3. Dynamic Item Value Estimator
Encapsulate valuation logic within the `Item` resource. Use `enum` rarity tiers and power level properties to dynamically calculate merchant prices.

```gdscript
# item_data_economy.gd
enum Rarity { COMMON, RARE, EPIC, LEGENDARY }
@export var rarity: Rarity = Rarity.COMMON
@export var base_value: int = 100

func get_value() -> int:
    var mult := 1.0
    match rarity:
        Rarity.RARE: mult = 2.0
        Rarity.EPIC: mult = 5.0
        Rarity.LEGENDARY: mult = 20.0
    return int(base_value * mult)
```

## Reference
- Master Skill: [godot-master](../godot-master/SKILL.md)
