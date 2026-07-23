---
name: godot-economy-system
description: "Expert patterns for game economies including currency management (multi-currency, wallet system), shop systems (buy/sell prices, stock limits), dynamic pricing (supply/demand), loot tables (weighted drops, rarity tiers), and economic balance (inflation control, currency sinks). Use for RPGs, trading games, or resource management systems. Trigger keywords: EconomyManager, currency, shop_item, loot_table, dynamic_pricing, buy_sell_spread, currency_sink, inflation, item_rarity."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Economy System

Wallet + transaction authority — not beginner "gold int" tutorials.

## Decision Tree: Currency Representation

| Economy type | Store as | Why |
|--------------|----------|-----|
| Soft currency (gold, scrap) with UI decimals | **`int` cents / smallest unit** | Exact math; display `value / 100.0` |
| Premium / idle quantities >> 2^31 | **BigInt / multi-limb int** (or carefully scaled `float` only if approx OK) | 32-bit `int` caps ~2.1B |
| Multiplayer / persistent wallet | **Authoritative `int` (or BigInt) on server** | Client never finalizes spends |
| Prices with fractional display only | Still **int smallest unit** | Avoid `0.1 + 0.2` float drift |

**NEVER** mix "use float for money" and "never use float for money" without this tree — pick one column and stick to it.

## NEVER Do in Economy Systems

- **NEVER skip buy/sell spread** — Same buy/sell price = infinite money.
- **NEVER skip currency sinks** — Repairs, taxes, fees, consumables prevent inflation.
- **NEVER validate spends only on the client** — Server/host is source of truth in multiplayer.
- **NEVER hardcode loot weights in scripts** — Use Resources ([loot_table_weighted.gd](scripts/loot_table_weighted.gd)).
- **NEVER subtract before `current >= amount`** — Underflow / negative wallets corrupt saves.
- **NEVER let UI mutate balances directly** — UI requests; [wallet_manager_singleton.gd](scripts/wallet_manager_singleton.gd) / [transaction_manager.gd](scripts/transaction_manager.gd) decides.
- **NEVER ignore transaction logs in serious RPGs** — Audit trail for missing currency.
- **NEVER exceed max caps without clamping** — Cap before wrap / overflow.

---

## Golden Path (MANDATORY)

1. [currency_resource.gd](scripts/currency_resource.gd) — denomination metadata
2. [wallet_manager_singleton.gd](scripts/wallet_manager_singleton.gd) — balances + signals
3. [transaction_manager.gd](scripts/transaction_manager.gd) — validated spend/grant pipeline
4. Shop / loot / UI only after wallet+transactions exist

**Delete** ad-hoc `EconomyManager` gold tutorials — do not re-inline wallet logic in scenes.

## Decision Points → Scripts

| Task | Load | Do NOT Load |
|------|------|-------------|
| Balances / Autoload wallet | wallet_manager_singleton.gd | Inline gold ints on Player |
| Spend/grant validation | transaction_manager.gd | UI calling `gold -= n` |
| Shop buy/sell + stock | shop_item_data.gd + shop_system_logic.gd | Equal buy/sell prices |
| Sales / reputation pricing | dynamic_price_modifier.gd | — |
| Weighted loot | loot_table_weighted.gd | Hardcoded `%` in enemy scripts |
| Loot → wallet bridge | loot_drop_economy_bridge.gd | — |
| HUD sync | currency_label_sync.gd | Polling wallet in `_process` without signals |
| Save wallet | economy_persistence_handler.gd | — |
| Pickup VFX | currency_pickup_effect.gd | — |
| Multi-item barter | trade_contract_resource.gd | — |

## Available Scripts (full catalog)

- [currency_resource.gd](scripts/currency_resource.gd)
- [wallet_manager_singleton.gd](scripts/wallet_manager_singleton.gd) — **MANDATORY**
- [transaction_manager.gd](scripts/transaction_manager.gd) — **MANDATORY**
- [shop_item_data.gd](scripts/shop_item_data.gd)
- [shop_system_logic.gd](scripts/shop_system_logic.gd)
- [dynamic_price_modifier.gd](scripts/dynamic_price_modifier.gd)
- [currency_label_sync.gd](scripts/currency_label_sync.gd)
- [loot_table_weighted.gd](scripts/loot_table_weighted.gd) — weights / rarity
- [loot_drop_economy_bridge.gd](scripts/loot_drop_economy_bridge.gd) — Do NOT Load if loot never grants currency
- [economy_persistence_handler.gd](scripts/economy_persistence_handler.gd)
- [currency_pickup_effect.gd](scripts/currency_pickup_effect.gd)
- [trade_contract_resource.gd](scripts/trade_contract_resource.gd) — Do NOT Load unless barter exists

## Elite Deltas

- **Barter contracts:** multi-item quid-pro-quo via trade_contract_resource (not single-currency shops).
- **GPM analytics:** log grants/sinks per minute for inflation detection.
- **Value estimator:** derive sell price from rarity + demand modifiers, always below buy.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Currencies, shop items, loot tables, and trade contracts belong as shareable `Resource` assets so designers can retune prices and drop weights without code changes.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — Use `duplicate()` when applying runtime price modifiers or per-merchant stock so one shop cannot mutate the shared `.tres` template for every vendor.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` buy/sell spreads, stock caps, currency ids, and loot weights so economy balance stays Inspector-driven.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — A WalletManager Autoload is the engine-supported pattern for balances that must survive scene changes (world ↔ shop ↔ menu).
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — Keep global wallet state in Autoload; keep merchant UI and one-off shop logic as scene nodes so tests and multiplayer authority stay composable.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `balance_changed` / `transaction_failed` so HUD labels and pickup VFX subscribe without writing wallet balances from the UI.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist wallet dictionaries (and stocked shop state) with the rest of progression data; never leave soft currency only in memory.
- [FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html) — Read/write save payloads that include economy blobs; pair with project `user://` paths for player-writable balance files.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Serialize `currency_id → amount` dictionaries as JSON-compatible structures for transparent save/load and analytics dumps.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — Weighted loot and drop rolls must use Godot RNG APIs (`randf`, seeded RNG) rather than ad-hoc modulo hacks.
- [RandomNumberGenerator](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html) — Seedable RNG instances make loot-table Monte Carlo and deterministic balance tests reproducible.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Spend/grant validation must be authoritative on the server; clients request transactions and apply confirmed balance RPCs only.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Currency, ShopItem, LootTable, and TradeContract definitions are Resource-first; load this before inventing parallel data formats for prices and drops.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — WalletManager as Autoload needs disciplined ownership, init order, and namespacing so economy state does not become a god-object dump.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Balance and transaction signals must stay “signal up / call down” so UI never mutates the wallet directly.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, Dictionary wallets, and atomic purchase helpers assume solid GDScript patterns (guards before subtract, no float money).

#### Complements
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Buy/sell and barter are atomic wallet↔inventory exchanges; stock and capacity checks belong with inventory, not only with price math.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Economy persistence handlers should plug into the project save schema (versioning, migrate, encrypt premium balances if needed).
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Charisma/reputation discounts and sink costs (repairs) need a consistent modifier layer rather than hardcoding multipliers in the shop UI.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Shop screens and currency HUD layouts should bind to wallet signals; containers own presentation, WalletManager owns truth.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Quest gold rewards and turn-in sinks are major currency sources/sinks; wire rewards through the transaction API, not ad-hoc `gold +=`.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Loot-drop bridges listen to combat/loot events and grant funds without embedding economy rules inside damage pipelines.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After sinks, loot weights, and shop spreads are Resource-driven, Monte Carlo farm/career sims prove inflation and time-to-afford bands before shipping curves.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Predicted UI spends and authoritative grant/spend RPCs build on the wallet’s request/validate/apply split.
- [godot-genre-idle-clicker](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md) — Idle/prestige currencies and sink loops assemble this skill with long-horizon balance and offline accrual genre glue.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Action-RPG shops, crafting sinks, and drop economies compose wallet + inventory + loot tables for progression pacing.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
