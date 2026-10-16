---
name: bevy-rea
description: "Emit a Bevy 0.20 crate from a GDAS-reader evidence ledger. Each confirmed or unknown entry becomes a plugin stub. Use after gdas-reader, not as a decompiler. Keywords: bevy-rea, reconstruction, ledger, emit_project, Bevy 0.20."
---

# bevy-rea

Turn a [GDAS-reader](gdas-reader.md) ledger into a Bevy 0.20 crate. Plugins are stubs. They do not reimplement the artifact.

## When to use

Load this when the ledger exists and the reconstruction target is Bevy. Run GDAS-reader first. Score that ledger at least 3 before emitting.

```powershell
python skills/gdas-reader/scripts/read_artifact.py P:\artifact --out P:\work\ledger.json
python skills/bevy-rea/scripts/emit_project.py P:\work\ledger.json --out P:\work\bevy-crate
python skills/bevy-rea/scripts/emit_project.py --self-test
```

## ECS shape

- **Crate:** `bevy = "0.20"` with the dev opt-level split from [bevy-project-foundations](project-foundations.md).
- **App:** `App::new()`, `DefaultPlugins`, then one plugin per ledger entry.
- **Components:** none until the suggested skill adds them. A stub system takes no `Query`.
- **Resources:** none by default. A score or config from a `partial` string stays out of the crate.
- **Systems:** `tick_<id>` on `Update`. The body is empty.

`unknown` entries still get a plugin so `COVERAGE.md` matches the module tree.

## What gets written

| Path | Role |
| --- | --- |
| `Cargo.toml` | Package `reconstructed`, Bevy 0.20. |
| `src/main.rs` | `DefaultPlugins` plus feature plugins. |
| `src/features/<id>.rs` | Plugin and empty system. Comment names ledger id, status, evidence, and the Bevy skill to load. |
| `placeholders/` or `assets/` | Placeholders when that entry's `license` is blank or `unspecified`. Copied bytes when `--allow-assets` and that entry's `license` are both set. |
| `COVERAGE.md` | Limits and one line per entry. |

## NEVER

- NEVER add a `Health` component because a symbol was named `apply_damage`. That entry is a stub until `bevy-combat-system` is loaded and the behavior is confirmed.
- NEVER copy asset bytes unless `--allow-assets` is set and that entry's `license` is not blank or `unspecified`. An unspecified license means the bytes are not yours to vendor.
- NEVER decompile native code or WASM into Rust. A stub is not a disassembly. Invented Rust from those bytes fails the honesty rubric.
- NEVER point this skill at a relative `../gdas-reader` path. Install layouts have no sibling folder. Use the GitHub URL in Related Skills.
- NEVER add Godot nodes, signals, or autoloads to the crate. Those types are not Bevy. Ownership stays a `Plugin` and an empty `Update` system until the suggested skill adds a `Component`.

## Honesty rubric

| Band | Rule |
| --- | --- |
| 0 | A system mutates gameplay state the ledger did not confirm. |
| 1 | Coverage drops an unknown id or omits `limits`. |
| 2 | Plugins exist but comments omit the Bevy skill. |
| 3 | Every entry is a plugin with an empty system and a coverage line. |
| 4 | `bevy = "0.20"` and `DefaultPlugins`. Assets are placeholders, or a licensed copy named from the module when `--allow-assets` was set. |

Ship at band 4.

Schedule rules: [references/ledger-to-ecs.md](rea-ledger-to-ecs.md).

## Available Scripts

### [rea_emit_project.py](../scripts/rea_emit_project.py)

Reads ledger JSON and writes the crate. `--self-test` checks the pin, the empty system, and that a damage-shaped name does not declare health.

## Reference

### Official Documentation

- [Getting started](https://bevy.org/learn/quick-start/getting-started/) — App setup the emitter follows.
- [Plugins](https://bevy.org/learn/quick-start/getting-started/plugins/) — `Plugin`, `DefaultPlugins`, and `add_plugins`.
- [ECS](https://bevy.org/learn/quick-start/getting-started/ecs/) — Systems stay empty until a Domain Skill adds components.
- [App](https://docs.rs/bevy/latest/bevy/app/struct.App.html) — `App::new` and `add_plugins`.
- [Plugin](https://docs.rs/bevy/latest/bevy/app/trait.Plugin.html) — one impl per ledger id.
- [Update](https://docs.rs/bevy/latest/bevy/app/struct.Update.html) — schedule for the empty stub.

## Related Skills

#### Prerequisites
- [gdas-reader](gdas-reader.md) — Writes the ledger.
- [bevy-project-foundations](project-foundations.md) — Crate pin and plugin boundary.

#### Complements
- [bevy-ecs-composition](ecs-composition.md) — Fill entity-shaped entries.
- [bevy-combat-system](combat-system.md) — Fill combat-shaped symbols.
- [bevy-input-handling](input-handling.md) — Fill input entries.
- [bevy-state-machines](state-machines.md) — Fill screen entries.
- [bevy-ui-layout](ui-layout.md) — Fill UI entries.
- [bevy-save-load](save-load.md) — Fill save entries.
- [bevy-asset-scenes](asset-scenes.md) — Fill asset entries after the license check.

#### Downstream / consumers
- [bevy-testing-patterns](testing-patterns.md) — `cargo test` once a stub gains real systems.

#### Master
- [bevy-master](../SKILL.md) — Router when the suggested skill is the wrong chain.
