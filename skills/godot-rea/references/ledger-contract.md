# Ledger contract

Emitters read this shape. They do not invent fields.

| Field | Use |
| --- | --- |
| `id` | Script file and node name. Hyphens become underscores. A second id that sanitizes to the same name gets `_2`. |
| `status` | `confirmed`, `partial`, or `unknown`. Only `confirmed` facts may later become gameplay, and only after the named Domain Skill is loaded. |
| `kind` | `screen`, `entity`, `input`, `asset`, `import`, `string`, or `symbol`. |
| `license` | Per asset entry. Blank or `unspecified` blocks copying. |
| `source_path` | Original file. Used when `copied` is absent. |
| `copied` | Path the reader already wrote. Preferred over `source_path` when it is a file. |
| `detail` | Collapsed to one comment line. A newline must not become a GDScript statement. |
| `suggested_skill_godot` | Skill named in the stub comment. |

## project.godot header

```ini
config/features=PackedStringArray("4.7", "Forward Plus")

[rendering]

renderer/rendering_method="forward_plus"
```

## Scene header

```ini
[gd_scene load_steps=N format=3]
```

No `uid://` attribute. Godot UID text is `a-z` and `0-9`. The editor assigns ids on import.

## Asset destination

`assets/<sanitized-id><suffix>` when `--allow-assets` is set and `license` is a real note. Otherwise `placeholders/<sanitized-id>.txt`. `COVERAGE.md` says `copied` or `placeholder` on that line.
