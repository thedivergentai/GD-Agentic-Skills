# Migration notes: godot-rea

Incremental upgrade for projects this skill emits. Apply **one hop**, stabilize/test, then next. Never skip hops.

If the project is **< 4.0**, follow [godot-version-migration](https://github.com/thedivergentai/Game-Dev-Agentic-Skills/blob/main/skills/godot-version-migration/SKILL.md) era bridges until 4.0, then these hops. Official 3→4: [Upgrading from Godot 3 to Godot 4](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.html).

Emitted projects target **Godot 4.7**. `project.godot` sets `config/features` to `PackedStringArray("4.7", "Forward Plus")` and `renderer/rendering_method` to `forward_plus`. Stubs use typed `-> void` and `res://` script paths. Re-run the emitter after an engine hop instead of hand-editing every stub.

## 3.x → 4.0

Official: [Upgrading from Godot 3 to Godot 4](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.html)

- Replace any hand-merged 3.x scene the reconstruction absorbed. The emitter writes Godot 4 `[gd_scene format=3]` only.
- `project.godot` feature tags are 4.x. A 3.x `config_version` will not open the emitted tree.

## 4.0 → 4.1

Official: [Upgrading to Godot 4.1](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.1.html)

- No emitter API change. Re-import if a filled-in stub called `get_meta_list` and stored a `PackedStringArray`.

## 4.1 → 4.2

Official: [Upgrading to Godot 4.2](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.2.html)

- No emitter API change.

## 4.2 → 4.3

Official: [Upgrading to Godot 4.3](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.3.html)

- Binary serialization of scripted Objects changed. Do not store ledger JSON inside a `.tres` and expect 4.2 editors to open it.

## 4.3 → 4.4

Official: [Upgrading to Godot 4.4](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.4.html)

- Inspector file exports become `uid://`. The emitter keeps `res://scripts/...` paths. After the first editor save, prefer the UID the editor writes.

## 4.4 → 4.5

Official: [Upgrading to Godot 4.5](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.5.html)

- Filled-in stubs must use `duplicate_deep(Resource.DEEP_DUPLICATE_ALL)` when they need the old deep-duplicate behavior.

## 4.5 → 4.6

Official: [Upgrading to Godot 4.6](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html)

- First 4.6 save adds unique node IDs to `scenes/main.tscn`. That diff is expected. Do not strip the IDs to make the ledger scene match the emitter output.

## 4.6 → 4.7

Official: [Upgrading to Godot 4.7](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html)

- Emitter feature tags are `4.7` and `Forward Plus`. `renderer/rendering_method` is `forward_plus`. A features array that is only `4.7` drops the renderer tag on the next editor save.
- New-project stretch defaults (`canvas_items` / `expand`) apply when the editor rewrites project settings. The emitter does not pin stretch mode.
- `Object.is_class` takes `StringName` if a filled-in stub checks class names.
