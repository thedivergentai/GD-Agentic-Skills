---
name: godot-save-load-systems
description: "Expert blueprint for save/load systems using JSON/binary serialization, PERSIST group pattern, versioning, and migration. Covers player progress, settings, game state persistence, and error recovery. Use when implementing save systems OR data persistence. Keywords save, load, JSON, FileAccess, user://, serialization, version migration, PERSIST group."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Save/Load Systems

JSON serialization, version migration, and PERSIST group patterns define robust data persistence.

## NEVER Do

- **NEVER save without a version field** — When you update your game's data structure, old saves will break. Always include a `"version": "1.0.0"` field and implement migration logic.
- **NEVER use absolute OS paths** — Hardcoding `C:/Users/...` will break on every other machine. Always use the `user://` protocol, which Godot maps to the correct OS-specific app data folder.
- **NEVER attempt to save Node references directly** — Nodes are objects, not raw data. Extract the necessary primitive data (positions, health, levels) into a `Dictionary` or `Resource` instead.
- **NEVER forget to close FileAccess handles** — Leaving a file open can lead to handle leaks and save-file corruption. In Godot 4, files auto-close when the variable goes out of scope, but explicit `close()` is safer for long-running logic.
- **NEVER use JSON for very large binary data** — Storing 10MB of texture data as Base64 in JSON is slow and bloats file size. Use binary `store_var()` or separate dedicated asset files.
- **NEVER trust loaded data without validation** — Users can edit save files. Always use `data.get("field", default_value)` and validate that numbers are within expected ranges to prevent crashes.
- **NEVER trigger a save during high-frequency physics or animation updates** — A crash mid-write will corrupt the file. Save only on explicit game events like entering a menu, finishing a level, or at a checkpoint.
- **NEVER modify a save Dictionary while iterating over its keys** — Calling `erase()` or `add()` inside a loop over the same dictionary causes iteration errors. Use `data.duplicate()` to iterate safely.
- **NEVER store raw passwords or sensitive credentials in unencrypted JSON** — If you have sensitive data, use `FileAccess.open_encrypted_with_pass()` to secure it.
- **NEVER use ResourceLoader.load() for massive scenes on the main thread** — It causes a visible freeze. Use `ResourceLoader.load_threaded_request()` to load levels in the background.
- **NEVER rely on get_instance_id() for cross-session identification** — These IDs are assigned at runtime and change every time the game restarts. Generate your own persistent `String` UUIDs for game objects.
- **NEVER forget to call duplicate(true) on a loaded Resource stats block** — If multiple enemies load the same "goblin_stats.tres", they will all share the same health pool unless duplicated.
- **NEVER use the "allow_objects" flag in store_var/get_var for untrusted data** — Setting this to `true` allows full object decoding, which is a major security risk for saves downloaded from the web.
- **NEVER use JSON for data requiring strict type preservation** — JSON converts `Vector3` to a string or dictionary. For strict data types, use `var_to_bytes()` or a binary format.
- **NEVER leave internal metadata (set_meta) in persistent dictionaries** — This unnecessarily inflates save file size. Clean your dictionaries before serialization.

---

## Available Scripts

> **MANDATORY**: Read the script for the chosen format before writing SaveManager code.

### [save_load_patterns.gd](../scripts/save_load_systems_save_load_patterns.gd)
**MANDATORY** for JSON / binary / PERSIST collect — patterns default `store_var(..., false)`.

### [save_migration_manager.gd](../scripts/save_load_systems_save_migration_manager.gd)
**MANDATORY** when any save has a `version` field that can lag the build.

### [save_system_encryption.gd](../scripts/save_load_systems_save_system_encryption.gd)
**MANDATORY** before encrypted slots — password from secure storage / user secret, never hardcoded in examples.

---

## Decision Tree: Pick a Persistence Shape

| Need | Format | MANDATORY |
|------|--------|-----------|
| Human-readable, small/medium progress | JSON + `version` | [save_load_patterns.gd](../scripts/save_load_systems_save_load_patterns.gd) |
| Type-faithful Variants / larger blobs | Binary `store_var` with **`allow_objects=false`** | same |
| Typed Resource trees / inspector schemas | `ResourceSaver` / `.tres`/`.res` | Peer `godot-resource-data-patterns` |
| Many scene nodes auto-collect | PERSIST group + `save()`/`load()` | [save_load_patterns.gd](../scripts/save_load_systems_save_load_patterns.gd) |
| Schema evolved | Migrate then load | [save_migration_manager.gd](../scripts/save_load_systems_save_migration_manager.gd) |
| Anti-tamper / sensitive fields | Encrypted FileAccess | [save_system_encryption.gd](../scripts/save_load_systems_save_system_encryption.gd) |

Do **not** paste Step 1–3 JSON Autoload tutorials here — implement from the scripts.

## `allow_objects` Trust Boundary

Default **always** `store_var(data, false)` / `get_var(false)`.

| Case | `allow_objects` | Rule |
|------|-----------------|------|
| Player `user://` saves, workshop mods, downloads | `false` | NEVER true — RCE risk |
| Trusted local only (your own tooling, offline debug fixtures you control) | `true` only if unavoidable | Document why; never ship as default; prefer Resources / Dictionaries of primitives |

Encrypted elite paths still use `false` unless the payload is explicitly trusted-local and non-user-editable.

## Golden Path (version → migrate → backup → atomic write)

1. **Version field** on every save blob.
2. **Migrate** via [save_migration_manager.gd](../scripts/save_load_systems_save_migration_manager.gd) when versions differ.
3. **Backup** existing file (`DirAccess.copy_absolute` to `.bak`) before overwrite.
4. **Write** to temp then rename, or write-after-backup; validate open errors.
5. **Integrity** optional: `FileAccess.get_sha256` compare; fall back to backup on mismatch.
6. **Paths** only `user://` — never absolute OS paths.
7. **When to save** — menu, checkpoint, level complete — never per physics frame.

Settings may use `ConfigFile` separately from run-progress JSON/binary.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist group serialization, JSON line format, and the canonical save/load loop this skill builds on.
- [File paths in Godot](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — `user://` vs `res://` mapping across OS app-data folders; never hardcode absolute paths.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — `store_var`/`get_var` Variant encoding, type fidelity, and why `allow_objects` is unsafe for untrusted saves.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_request` for hitch-free level/resource loads after a save restore.
- [File system](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html) — FileAccess/DirAccess workflow for existence checks, backups, and safe overwrite patterns.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Resource vs Dictionary persistence, `duplicate(true)`, and when `.tres`/`.res` beats hand-rolled JSON.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — SceneTree group membership used by the Persist/PERSIST auto-collect pattern.
- [FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html) — Open modes, encrypted-with-pass AES helpers, SHA-256, compression flags, and buffer I/O.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — `stringify`/`parse`/`parse_string` for human-readable saves and validation of parse errors.
- [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html) — INI-style settings (`user://settings.cfg`) separate from full game-state saves.
- [ResourceSaver](https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html) — Persist typed Resources/custom Resource trees when JSON type loss is unacceptable.
- [AESContext](https://docs.godotengine.org/en/stable/classes/class_aescontext.html) — Low-level AES block encrypt/decrypt used by custom compressed encrypted save pipelines.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — ProjectSettings, Autoload registration, and `user://` project identity must exist before a SaveManager can own paths.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Dictionaries, Resources, and error-handling patterns for versioned serialize/deserialize code.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — SaveManager is almost always an Autoload; use this for singleton ownership, boot order, and scene-change survival.

#### Complements
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Custom Resource schemas and `.tres` workflows that pair with ResourceSaver instead of flattening everything to JSON.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Threaded scene swaps and wipe/rebuild Persist nodes after load without leaking old world state.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `game_saved` / `game_loaded` event buses so UI and systems react without hard-wiring SaveManager.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Settings menus that write ConfigFile/volume keys this skill persists separately from run progress.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Item stacks and equipment dictionaries are the heaviest Persist payloads; share ID schemes with save migration.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Quest flags/stage IDs must round-trip through versioned saves without breaking journal UI.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Currency wallets and shop unlocks need the same version field and validation as player progress.

#### Downstream / consumers
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Local save patterns become host-authoritative state sync; never trust client-edited JSON in multiplayer.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Use when progression/economy curves stored in saves need simulated balance passes against migration defaults.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Server-side validation and snapshot formats that replace plaintext `user://` saves for competitive modes.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns persistence vs content systems.
