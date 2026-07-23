# Aurelius Protocol: Economy System NEVER List

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
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
