---
name: gdas-reader
description: "GDAS-reader turns a source tree, web bundle, asset folder, WASM module, or PE/ELF file into an evidence ledger for godot-rea or bevy-rea. Use before emitting a Godot or Bevy reconstruction. Keywords: GDAS-reader, ledger, read_artifact, reconstruction, evidence."
---

# GDAS-reader

Read an artifact and write `ledger.json`. This skill does not create a Godot scene or a Bevy crate. [godot-rea](rea.md) and [bevy-rea](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/bevy-rea/SKILL.md) do that from the ledger.

## When to use

Load this when the input is a folder or a shipped file and the output must be a reconstruction in Godot or Bevy. Run the reader first. Hand the ledger to one emitter.

```powershell
python skills/gdas-reader/scripts/read_artifact.py P:\artifact --out P:\work\ledger.json
python skills/gdas-reader/scripts/read_artifact.py --self-test
```

A hub-only install uses the copy under Available Scripts: [gdas_reader_read_artifact.py](../scripts/gdas_reader_read_artifact.py).

Schema: [references/ledger.md](gdas-reader-ledger.md).

## What the reader records

| Artifact | Confirmed facts | What stays partial or unknown |
| --- | --- | --- |
| Source tree | Declarations, including `class_name`, `async fn`, and `pub(crate) fn`. UI-shaped string literals. | State-looking names (`state`, `phase`, `mode`) stay `partial`. |
| Web bundle | Document title outside script and style, headings, script URLs, image URLs, JSON key paths for every array element | Behavior inside minified scripts. A folder is also scanned for source, assets, and WASM instead of dropping them. |
| Asset folder | File path, media type, and `source_path` | Bytes stay put unless `--allow-assets` and a real `--license-note` are both set |
| WASM | Export names, import module and field names, up to 10 ASCII runs | Function bodies. Non-ASCII text. A truncated section becomes `unknown` instead of a crash. |
| PE or ELF | Format identification and readable strings | Machine code. A `.dll` or `.so` string is `partial` because the import table is not walked. A short header becomes `unknown`. |

The reader is stdlib Python. It does not call an external decompiler. A native binary contributes a header walk, imports, and strings. Packed or encrypted sections become `unknown` entries.

## Ledger honesty

Score the ledger before an emitter runs. Bands are additive. A ledger below 3 does not get emitted as gameplay.

| Band | Rule |
| --- | --- |
| 0 | Entries claim behavior the file does not show. |
| 1 | Status is missing, or every guess is marked `confirmed`. |
| 2 | Status values exist, but `limits` hides a format the reader cannot parse. |
| 3 | Each entry has `id`, `status`, `evidence`, and a skill suggestion. `unknown` is listed. |
| 4 | Caps and license gaps are in `limits`. No asset bytes were copied. Partial names are not described as working mechanics. |

## NEVER

- NEVER mark a symbol `confirmed` because its name looks like health, damage, or save. Those matches are `partial`.
- NEVER copy image, audio, or glTF bytes unless both `--allow-assets` and `--license-note` are set. A note alone records the license and still leaves the bytes in place.
- NEVER decompile native code, WASM bodies, or minified JavaScript to invent a mechanic.
- NEVER drop `limits` when the scan hit the 40-entry cap or the file was packed.
- NEVER point `godot-rea` or `bevy-rea` at a relative `../gdas-reader` path. Link the GitHub URL above so a single-skill install still names the prerequisite.

## Available Scripts

### [gdas_reader_read_artifact.py](../scripts/gdas_reader_read_artifact.py)

Classifies a file or directory and writes the ledger. `--self-test` checks fixtures. `--license-note` records a license. `--allow-assets` copies bytes into `copied-assets/` next to `--out` and requires that note.

## Related Skills

#### Prerequisites
- None. This skill is the first step.

#### Complements
- [godot-rea](rea.md) — Godot 4.7 project emitted from this ledger.
- [bevy-rea](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/bevy-rea/SKILL.md) — Bevy 0.20 crate emitted from this ledger.

#### Downstream / consumers
- [godot-builder](builder.md) — Headless import after `godot-rea` writes scenes.
- [bevy-project-foundations](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/bevy-project-foundations/SKILL.md) — Crate pin and plugin shape the Bevy emitter follows.

#### Master
- Mirrored inside [godot-master](../SKILL.md) and [bevy-master](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/bevy-master/SKILL.md). A hub-only install still has this reader.
