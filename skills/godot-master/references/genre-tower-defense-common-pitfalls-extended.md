# Common Pitfalls

1.  **Death Spirals**: If a player leaks one enemy, they lose money/lives, making the next wave harder, leading to inevitable failure. **Fix**: Catch-up mechanics or discrete wave difficulty.
2.  **Useless Towers**: Every tower type must have a distinct niche (AoE, Slow, Armor Pierce, Anti-Air).
3.  **Path Blocking**: In mazing games, ensure players cannot completely block the path to the exit. Use `NavigationServer2D.map_get_path` to validate placement before building.
