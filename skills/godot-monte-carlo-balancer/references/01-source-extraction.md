# Phase 1 — Source Extraction Layer (`extract.rs`)

**Goal:** A dynamic parser that turns live game source into a typed `GameData` at every startup. No config files, no manual sync, no busywork. When a designer edits a `.gd` file, the next simulation run already uses the new values.

## Architecture

```rust
pub fn extract_game_data(root: &Path) -> Result<GameData> {
    Ok(GameData {
        weapons: extract_weapons(root)?,
        enemies: extract_enemies(root)?,
        traps: extract_traps(root)?,
        levels: extract_levels(root)?,
        modes: extract_modes(root)?,
        constants: extract_constants(root)?, // engine constants + embedded formulas
    })
}
```

One extraction function per content class, all pure `&Path -> Result<Vec<T>>`, all built from small reusable helpers.

## Core helpers (reuse these patterns)

```rust
fn read(root: &Path, rel: &str) -> Result<String>            // read a game file, error with path context
fn capture_f64(src: &str, pattern: &str, default: f64) -> f64 // single-value regex capture
fn capture_i32(src: &str, pattern: &str, default: i32) -> i32
fn get_s / get_i / get_f64(fields, key, default)              // typed access into a parsed block
```

**Rule:** every `default` that actually gets used must be surfaced in `inspect` output (e.g. suffix the value with `(default!)`). Silent defaults are how balancers lie.

## Pattern 1 — Factory/profile blocks

Godot data-driven games typically define content as static factory functions assigning to a profile object:

```gdscript
static func create_stapler() -> WeaponProfile:
    var profile := WeaponProfile.new()
    profile.damage = 12
    profile.fire_interval = 0.45
    profile.magazine = 30
    return profile
```

Extract with a header regex per class plus a generic key-value regex:

```rust
fn factory_blocks(src: &str, class_name: &str) -> Vec<(String, HashMap<String, String>)> {
    // header: static func create_([a-z_0-9]+) ... -> ClassName
    // fields: (?m)^\s*profile\.([a-z_]+)\s*=\s*(.+?)\s*$
}
```

This makes the parser resilient to **new fields and new instances**: adding a weapon or property in GDScript requires zero parser changes unless a new *shape* of definition appears.

## Pattern 2 — Constants and typed vars

```rust
let const_re = Regex::new(r"(?m)^const (\w+):\s*float\s*=\s*([\d.]+)").unwrap();
let var_re   = Regex::new(r"^var (\w+)(?::\s*[\w.]+)?\s*=\s*(.+)$").unwrap();
let array_re = Regex::new(r"TRAP_SLOT_UNLOCK_LEVELS: Array\[int\] = \[([\d,\s]+)\]").unwrap();
```

Resolve symbolic references: parse scalars that may be numbers, bools, or names of previously-captured constants (`parse_scalar(raw, &constants)`).

## Pattern 3 — Embedded formulas (critical!)

Difficulty and reward curves usually live inline in gameplay code, not in data:

```gdscript
var hp_scale := 1.0 + (0.08 + 0.03 * _definition.id) * wave
cash = 40 + level_data.id * 15
```

Extract the **coefficients** with formula-shaped regexes and store them as named constants:

```rust
let hp_re   = Regex::new(r"1\.0 \+ \(([\d.]+) \+ ([\d.]+) \* _definition\.id\)").unwrap();
let cash_re = Regex::new(r"cash = (\d+) \+ level_data\.id \* (\d+)").unwrap();
```

Then reimplement the formula once in `model.rs`/`sim.rs` using the extracted coefficients. If the game formula changes shape (not just coefficients), the regex fails → the tool errors loudly → you update both together. That is the correct failure mode.

## Pattern 4 — Structured code sections (modes, level definitions)

For `match`-based rule blocks:

```rust
let kind_re = Regex::new(r"^\s*Kind\.(\w+):\s*$").unwrap();   // section header
let rule_re = Regex::new(r"^\s*rules\.(\w+)\s*=\s*(.+)$").unwrap(); // assignments inside
```

Walk lines, track the current section, apply assignments via a single `apply_mode(&mut mode, name, value)` dispatcher so new rule fields need one match arm, not a new parser.

For level definitions built in code (`var lvl := _base_level(3, "Server Room", "...")` followed by `lvl.spawn_interval = 1.2`), capture the constructor call and then generic `ident.field = number` assignments, routed through `set_level_field(&mut level, name, raw)`.

## Project root discovery

```rust
pub fn find_project_root() -> Result<PathBuf>
```

- Walk up from the executable/cwd looking for the engine marker (`project.godot`, `*.uproject`, `package.json`, ...).
- Support an env override (`BALANCE_LAB_PROJECT_ROOT`) for running a copied binary outside the tree.
- Error with a clear message listing what was searched.

## The `inspect` command (mandatory)

`inspect` pretty-prints **everything** extracted: every profile with every field, every constant, every formula coefficient, every mode's effective rules (`GameMode::describe()`), every level's curve values, and flags any defaulted field. Also provide `--json` (`GameData::inspect_json()`).

**Workflow rule:** after writing or modifying any extractor, run `inspect` and diff it against the source by eye (or have the agent verify field-by-field) before running a single simulation.

## Keeping extraction honest over time

- Add a smoke test that runs `extract_game_data` against the repo and asserts non-empty catalogs and a few known-stable invariants (e.g. at least one weapon has `damage > 0`).
- When a parse fails after a game refactor, fix the extractor **first**, re-verify `inspect`, then resume balancing.
- Never cache `GameData` to disk between runs. Extraction is fast; staleness is fatal.

## Non-Godot sources

The same layered approach works for JSON/YAML/CSV data (use `serde` directly — even better), Unity `ScriptableObject` YAML, C# constants, or Lua tables. Prefer real deserialization when the game already has structured data; fall back to regex extraction only for values embedded in code. See `06-genre-adaptation.md`.
