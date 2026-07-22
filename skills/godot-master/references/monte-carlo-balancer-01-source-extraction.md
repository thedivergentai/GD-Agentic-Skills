# Phase 1 — Source Extraction Layer (`extract.rs`)

**Goal:** Turn live game source into typed `GameData` at every startup. No hand-copied config. When a designer edits a Resource or coefficient, the next run uses the new values.

## Decision tree (Resource-first)

```text
1. Does balance data live in .tres / Resource / CSV→.tres?
   YES → deserialize (preferred). Skip regex for those fields.
2. Does it live in GDScript const / @export on a Resource script?
   YES → parse typed assignments; still prefer loading .tres instances.
3. Are coefficients embedded only in gameplay formulas?
   YES → targeted regex for coefficients; reimplement formula once in sim.
4. Still no data layer?
   STOP → apply godot-resource-data-patterns (+ economy/combat Resources), then return to 1.
```

**Anti-pattern:** Building a regex farm for a project that already has `WeaponProfile` / `EnemyStats` Resources. That fights the GDSkills data culture and rot-proofing.

## Architecture

One pure extractor per Phase 0 content class: `&Path -> Result<T>`. Assemble into `GameData`. No on-disk `GameData` cache between runs.

## Preferred path — `.tres` / Resources

Godot `.tres` is INI-like (sections + `key = value`). Parse sections into typed structs, or:

1. Add a tiny Godot `--script` / editor tool that dumps Resources to JSON (stable field names).
2. Have Rust `serde_json` load that dump via `balance-lab extract` / startup.

Prefer JSON dump when Resource graphs are deep (nested subresources, PackedArrays). Keep the dump **generated at extract time**, never hand-edited.

CSV→`.tres` pipelines (`godot-genre-simulation`) are ideal: extract from the same CSV designers already balance, or from baked `.tres`.

## Fallback — GDScript constants / factory blocks

Use only when Phase 0 marked no Resource truth:

```rust
fn factory_blocks(src: &str, class_name: &str) -> Vec<(String, HashMap<String, String>)> {
    // header: static func create_([a-z_0-9]+) ... -> ClassName
    // fields: (?m)^\s*profile\.([a-z_]+)\s*=\s*(.+?)\s*$
}
```

Helpers: `read`, `capture_f64` / `capture_i32`, typed field getters. **Every default that fires must show `(default!)` in `inspect`.**

## Critical — embedded formulas

Difficulty/reward curves often live inline:

```gdscript
var hp_scale := 1.0 + (0.08 + 0.03 * _definition.id) * wave
```

Extract **coefficients** with formula-shaped regexes; store as named constants; reimplement once in `model.rs`/`sim.rs`. Shape change → regex fails loudly → update extract + sim together. That is the correct failure mode.

## Project root discovery

Walk up for `project.godot` (or engine marker). Support `BALANCE_LAB_PROJECT_ROOT` env override. Error with searched paths listed.

## `inspect` (mandatory)

Pretty-print everything extracted; flag defaults; provide `--json` (`GameData::inspect_json()`). After any extractor change: `inspect` + field-by-field verify before the first simulate.

## Honesty over time

- Smoke test: non-empty catalogs + a few stable invariants (`damage > 0`, …).
- On game refactor parse failure: fix extractor first, re-`inspect`, then resume balancing.
- Never cache `GameData` across game-source edits.

## Non-Godot / other engines

Prefer real deserialization (JSON/YAML/CSV) when available. Regex only for values embedded in code. See [06-genre-adaptation.md](monte-carlo-balancer-06-genre-adaptation.md).
