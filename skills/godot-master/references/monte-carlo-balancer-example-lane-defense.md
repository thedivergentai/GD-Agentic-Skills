# Reference specialization — Lane Defense

**Status:** Example only. Do **not** use these field names as the default `GameData` / `RunResult` shape. Map them from the abstract model in Phase 0 when the target game is lane defense / shift-based tower-shooter.

Contributed patterns originated in a Godot 4.x lane-defense Balance Lab (weapons, traps, jams/overheat, barricade HP, wave leaks).

## Abstract → lane-defense map

| Abstract | Lane defense |
|----------|--------------|
| Session | One shift (wave sequence) |
| Threat | Enemy waves vs barricade |
| Defense | Weapon + traps + upgrades |
| Faults | Jams / overheat minigames |
| Resources | Ammo / supplies / heat |
| In-run economy | Cash → traps/upgrades |
| Meta economy | Stars → store |
| Grade | Stars by HP remaining |

## Example `PlayStyle` extensions

Lane defense adds trap/upgrade spend axes on top of core reaction params:

- `places_traps`, `trap_budget_fraction`
- `buys_upgrades`, `upgrade_cash_reserve`
- Fault reaction vs supply reaction as separate mean/sigma pairs
- Reference afk→pro table (tune per game): slower reactions / higher lapse for afk; higher trap budget for pro

## Example `RunResult` texture fields

`barricade_hp`, `leaks_by_kind`, `jams`, `overheats`, `fault_downtime`, `empty_downtime`, `ammo_wasted`, `supplies_missed`, `traps_placed`, `coins_new_best` vs `coins_replay`, `peak_heat_ratio`, `time_to_first_fault`.

## Example sim update slices

`update_spawning`, `update_supplies`, `update_cooling_and_clearing`, `update_firing`, `update_projectiles_and_traps`, `update_enemies`, `maybe_buy_upgrade`, trap placement helpers.

## Extraction smells from that reference

- Factory `create_*() -> WeaponProfile` blocks in `.gd` (migrate to Resources when possible).
- Inline HP scale: `1.0 + (a + b * level_id)`.
- Mode rules inside `match Kind.X:` with `rules.field = value`.
- Shop catalogs and trap-slot unlock arrays in progression scripts.

## Example extract→inspect smell (lane defense)

After `inspect`: HP scale coeffs `(0.08, 0.03)` match `wave_spawner.gd`; weapon `stapler.damage=12` matches factory; one enemy shows `speed=1.0 (default!)` → **stop** — regex missed the field; fix extract before any matrix. Do not invent a full sim from this file — use Phase 2 abstract types.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_json.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
-->
