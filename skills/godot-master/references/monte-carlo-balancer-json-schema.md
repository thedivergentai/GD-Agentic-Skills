# Balance Lab JSON field contract

Stable names for `--json` output. Agents and CI must not rename these without a version bump (`schema_version`).

## Top-level envelope

```json
{
  "schema_version": 1,
  "command": "simulate",
  "seed": 42,
  "runs": 1000,
  "game_data_hash": "0164hex-or-u64-string",
  "cells": [ /* Aggregate */ ]
}
```

## `Aggregate` (matrix cell)

| Field | Type | Notes |
|-------|------|-------|
| `session_id` | int/string | Level / floor / shift id |
| `style` | string | `afk`, `casual`, … |
| `loadout_id` | string | Stable id |
| `n` | int | Runs in cell |
| `win_rate` | float | Point estimate 0–1 |
| `win_rate_ci_low` | float | Wilson/bootstrap low |
| `win_rate_ci_high` | float | Wilson/bootstrap high |
| `verdict` | string | `OK` / `TOO_HARD` / `TOO_EASY` / `INCONCLUSIVE` |
| `grade_hist` | object | e.g. `{"0":10,"1":20,"2":30,"3":40}` |
| `time_avg` | float | Seconds |
| `currency_per_minute` | float | optional; modes/careers |
| `warnings` | string[] | anomaly callouts |

Game-specific texture metrics may appear under `metrics` (object) without breaking CI that only diffs envelope + core fields.

## `inspect` envelope

```json
{
  "schema_version": 1,
  "command": "inspect",
  "game_data_hash": "...",
  "defaults_used": [ {"path": "enemies[2].hp", "value": 10} ],
  "catalogs": { }
}
```

## Career envelope

Include `purchases` (array of `{item_id, minute_median, minute_p90}`), `replay_vs_frontier_ratio`, and `flags` (`UNREACHABLE_SHOP`, `DOMINANT_FARM`, …).

## Diff rules

`compare_balance_snapshots.py` keys cells by `(session_id, style, loadout_id)`. Refuse compare if `schema_version`, `seed`, or `runs` disagree (unless `--force`).
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
