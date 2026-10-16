# Evidence ledger

`scripts/read_artifact.py` writes one JSON object. Emitters in `godot-rea` and `bevy-rea` consume this file and must not add behavior the entries do not support.

```json
{
  "source": "P:/artifact",
  "kind": "source",
  "limits": ["Native code is not decompiled."],
  "entries": [
    {
      "id": "src-001",
      "status": "confirmed",
      "kind": "symbol",
      "name": "apply_damage",
      "detail": "Declaration found in source text.",
      "evidence": "src/player.py",
      "suggested_skill_godot": "godot-combat-system",
      "suggested_skill_bevy": "bevy-combat-system"
    }
  ]
}
```

## Status

| Status | Meaning |
| --- | --- |
| `confirmed` | The artifact shows the fact directly (a screen title, an import name, a file path, an exported WASM name). |
| `partial` | A name or string suggests a feature. The rule fired. The behavior is not proven. |
| `unknown` | The reader saw bytes it cannot interpret. Emitters leave a stub and copy this id into `COVERAGE.md`. |

## Kind

`screen`, `entity`, `input`, `asset`, `import`, `string`, `symbol`.

`kind` on the document is the artifact class: `source`, `web`, `assets`, `wasm`, `pe`, `elf`, `mixed`, or `unknown`. `mixed` means the folder held more than one class. Each class is scanned. A folder is not reduced to the single highest score.

## Caps

Each class keeps at most 40 entries. A truncated scan is recorded in `limits`. Printable-string scans that stop at 10 or 30 also record a limit. Asset bytes are copied only when `--allow-assets` and a license note other than blank or `unspecified` are both set. The copy is `copied-assets/` beside `--out`. Each copied entry records `source_path` and `copied`. A `.dll` or `.so` string is `partial`. The import table and the dynamic section are not walked.
