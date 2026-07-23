# Aurelius Protocol: Save Load Systems NEVER List

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
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
