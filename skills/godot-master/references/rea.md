---
name: godot-rea
description: "Emit a Godot 4.7 project from a GDAS-reader evidence ledger. Stubs name the ledger id and the Domain Skill to load. Use after gdas-reader, not as a decompiler. Keywords: godot-rea, reconstruction, ledger, emit_project, Godot 4.7."
---

# godot-rea

Turn a [GDAS-reader](gdas-reader.md) ledger into a Godot 4.7 project. The project is a scaffold of stubs. It is not a port of machine code.

## When to use

Run this after `read_artifact.py` has written `ledger.json` and the honesty rubric in GDAS-reader scores at least 3. Then open the Domain Skill named on each stub before writing gameplay.

```powershell
python skills/gdas-reader/scripts/read_artifact.py P:\artifact --out P:\work\ledger.json
python skills/godot-rea/scripts/emit_project.py P:\work\ledger.json --out P:\work\godot-project
python skills/godot-rea/scripts/emit_project.py --self-test
```

## What gets written

| Path | Role |
| --- | --- |
| `project.godot` | Godot 4.7 project. Features are `4.7` and `Forward Plus`. Renderer is `forward_plus`. Main scene is `res://scenes/main.tscn`. The scene file has no `uid://` line. The editor writes UIDs on import. |
| `scenes/main.tscn` | One child node per ledger entry. The node name is the ledger id, not the display name, so two entries cannot share a sibling name. |
| `scripts/<id>.gd` | Stub. Comment carries ledger id, status, evidence path, and the Godot skill to load. `_ready` is `pass`. |
| `placeholders/` or `assets/` | Placeholders when the license is unspecified. Copied bytes when `--allow-assets` and the ledger license are both set. |
| `COVERAGE.md` | Limits plus one line per entry. |

`--allow-assets` copies bytes into `assets/<ledger-id>.<ext>` when that entry's `license` is not blank or `unspecified`. It prefers the reader's `copied` path, then `source_path`. Without that pair, the emitter writes `placeholders/` and leaves the bytes alone.

## Expert Knowledge Delta

- A `confirmed` declaration means the name exists in the artifact. It does not mean the Godot function should reproduce that body. Load the suggested skill and re-implement the behavior you are allowed to write.
- A `partial` string from a PE or ELF scan is a hint. The reader does not walk the import table, so a `.dll` string is not a confirmed import. Wiring it to `health` or a signal without a second source of truth fails the honesty rubric.
- `unknown` entries still get a node so coverage stays visible. Leaving them out makes the project look finished.
- Headless `ResourceSaver` does not write UIDs. The emitter omits `uid://` because `uid://rea_main` is illegal: `ResourceUID` text is `a-z` and `0-9` only, and an underscore returns `INVALID_ID`. After import, [godot-builder](builder.md) runs `godot -e --headless --import`.
- `config/features` must include both `4.7` and `Forward Plus`, and `renderer/rendering_method` must be `forward_plus`. A features array that is only `4.7` loses the renderer tag the next time the editor saves the project.
- The text loader sets `owner` to the scene root when a node has `parent="."` and no owner field. `parent` is not that assignment. `Node.duplicate()` does not copy owner. A later `PackedScene.pack` drops children whose owner is unset, so that step must `set_owner` on the copy and each child.
- Godot 4.7 new projects stretch with `canvas_items` and `expand` once the editor rewrites settings. The emitter does not pin stretch. See [references/migration-notes.md](rea-migration-notes.md) and [references/ledger-contract.md](rea-ledger-contract.md).

## NEVER

- NEVER invent damage formulas, scene flow, or input maps that the ledger does not state. A `partial` or `unknown` row is not a mechanic. Band 0 is that failure.
- NEVER mark a stub done by deleting `pass` and guessing a method body. The stub is done when the named Domain Skill replaces it.
- NEVER copy asset bytes unless `--allow-assets` is set and that entry's `license` is not blank or `unspecified`. An unspecified license means the bytes are not cleared to vendor into the project.
- NEVER decompile the original binary to fill a stub. The reader did not prove a function body, and a disassembly is not a Godot function.
- NEVER link this skill to GDAS-reader with a relative `../gdas-reader` path. A single-skill install has no sibling folder. Use the GitHub URL in Related Skills.
- NEVER add a `## Godot 4.7 Baseline` section here. Hop text stays in `references/migration-notes.md`.

## Honesty rubric

| Band | Rule |
| --- | --- |
| 0 | Emitted GDScript implements a mechanic the ledger marked `partial` or `unknown`. |
| 1 | `COVERAGE.md` omits limits or drops unknown ids. |
| 2 | Stubs exist but comments omit the skill name. |
| 3 | Every entry has a script, a coverage line, and a `pass` body. Comments are single lines. |
| 4 | Feature tags are `4.7` and `Forward Plus`. Suggested skills match the ledger. Assets are placeholders, or a licensed copy named from the ledger id when `--allow-assets` was set. |

Ship at band 4.

## Available Scripts

### [rea_emit_project.py](../scripts/rea_emit_project.py)

Reads ledger JSON and writes the project tree. `--self-test` checks the Forward Plus feature tag, a comment that cannot become a statement, a placeholder when the license is unspecified, and a licensed copy under `--allow-assets`.

Field table and scene header: [references/ledger-contract.md](rea-ledger-contract.md).

## Reference

### Official Documentation

- [Godot projects](https://docs.godotengine.org/en/stable/tutorials/editor/project_manager.html) — Project file and main scene the emitter writes.
- [Scenes and nodes](https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html) — Node tree the main scene uses for one stub per entry.
- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) — Typed `_ready` stubs.
- [Upgrading to Godot 4.7](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html) — Feature tag and stretch defaults.

## Related Skills

#### Prerequisites
- [gdas-reader](gdas-reader.md) — Writes the ledger this skill emits.
- [godot-project-foundations](project-foundations.md) — Folder and project conventions for the scaffold.
- [godot-builder](builder.md) — Headless import after the files exist.

#### Complements
- [godot-composition](composition.md) — Fill entity-shaped stubs.
- [godot-combat-system](combat-system.md) — Fill combat-shaped symbols.
- [godot-input-handling](input-handling.md) — Fill input entries.
- [godot-ui-containers](ui-containers.md) — Fill UI entries.
- [godot-save-load-systems](save-load-systems.md) — Fill save entries.

#### Downstream / consumers
- [godot-testing-patterns](testing-patterns.md) — Tests for stubs once a skill replaces `pass`.

#### Master
- [godot-master](../SKILL.md) — Router when a stub's suggested skill is the wrong chain.
