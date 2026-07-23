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

One pure extractor per Phase 0 content class: `&Path -> Result<T>`. Assemble into `GameData`. No on-disk `GameData` cache between runs.

## Preferred path — `.tres` / Resources

Godot `.tres` is INI-like (sections + `key = value`). Parse sections into typed structs, or:

1. Add a tiny Godot `--script` / editor tool that dumps Resources to JSON (stable field names).
2. Have Rust `serde_json` load that dump via `balance-lab extract` / startup.

Prefer JSON dump when Resource graphs are deep (nested subresources, PackedArrays). Keep the dump **generated at extract time**, never hand-edited.

CSV→`.tres` pipelines (`godot-genre-simulation`) are ideal: extract from the same CSV designers already balance, or from baked `.tres`.

## Core helpers (reuse these patterns)

```rust
fn read(root: &Path, rel: &str) -> Result<String>            // read a game file, error with path context
fn capture_f64(src: &str, pattern: &str, default: f64) -> f64 // single-value regex capture
fn capture_i32(src: &str, pattern: &str, default: i32) -> i32
fn get_s / get_i / get_f64(fields, key, default)              // typed access into a parsed block
```

**Rule:** every `default` that actually gets used must be surfaced in `inspect` output (e.g. suffix the value with `(default!)`). Silent defaults are how balancers lie.

## Fallback — GDScript constants / factory blocks

Use only when Phase 0 marked no Resource truth.

### Pattern 1 — Factory/profile blocks

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

### Pattern 2 — Constants and typed vars

```rust
let const_re = Regex::new(r"(?m)^const (\w+):\s*float\s*=\s*([\d.]+)").unwrap();
let var_re   = Regex::new(r"^var (\w+)(?::\s*[\w.]+)?\s*=\s*(.+)$").unwrap();
let array_re = Regex::new(r"TRAP_SLOT_UNLOCK_LEVELS: Array\[int\] = \[([\d,\s]+)\]").unwrap();
```

Resolve symbolic references: parse scalars that may be numbers, bools, or names of previously-captured constants (`parse_scalar(raw, &constants)`).

### Pattern 3 — Embedded formulas (critical!)

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

### Pattern 4 — Structured code sections (modes, level definitions)

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

- Walk up from the executable/cwd looking for the engine marker (`project.godot`, `*.uproject`, `package.json`, …).
- Support an env override (`BALANCE_LAB_PROJECT_ROOT`) for running a copied binary outside the tree.
- Error with a clear message listing what was searched.

## `inspect` (mandatory)

Pretty-print everything extracted: every profile with every field, every constant, every formula coefficient, every mode's effective rules (`GameMode::describe()`), every level's curve values, and flags any defaulted field. Also provide `--json` (`GameData::inspect_json()`).

**Workflow rule:** after writing or modifying any extractor, run `inspect` and diff it against the source by eye (or have the agent verify field-by-field) before running a single simulation.

## Honesty over time

- Smoke test: non-empty catalogs + a few stable invariants (`damage > 0`, …).
- On game refactor parse failure: fix extractor first, re-`inspect`, then resume balancing.
- Never cache `GameData` across game-source edits.

## Non-Godot / other engines

Prefer real deserialization (JSON/YAML/CSV) when available. Regex only for values embedded in code. See [06-genre-adaptation.md](06-genre-adaptation.md).
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
