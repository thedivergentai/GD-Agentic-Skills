# Aurelius Protocol: Game Loop Time Trial NEVER List

- **NEVER use OS.get_ticks_msec() for ultra-precise race timing** — Millisecond resolution is too coarse for high-end racing games. Use `Time.get_ticks_usec()` for microsecond precision.
- **NEVER rely exclusively on _process() for finish line triggers** — Visual frames can skip during lag. Always evaluate physical overlaps in `_physics_process()` to guarantee detection within the fixed physics step.
- **NEVER evaluate Area3D overlaps immediately after instantiation** — The physics server requires at least one physics frame to synchronize. `await get_tree().physics_frame` before checking for players.
- **NEVER scale a CollisionShape3D on a checkpoint non-uniformly** — This breaks the underlying SAT collision math. Always scale the internal shape resource (e.g., `BoxShape3D.size`) instead.
- **NEVER use TCP (reliable) for syncing positions in multiplayer racing** — Congestion algorithms cause huge spikes. Use `ENetMultiplayerPeer` with `TRANSFER_MODE_UNRELIABLE` for high-frequency position updates.
- **NEVER trust client-side finish line/lap crossing** — Always validate triggers on the authoritative server using `multiplayer.is_server()` to prevent cheating.
- **NEVER use standard float equality (==) for record lap times** — Use `is_equal_approx()` to account for precision loss in accumulated time variables.
- **NEVER hardcode input checks without flushing the buffer** — For frame-perfect boost/stop responses, call `Input.flush_buffered_events()` to ensure the engine has processed the latest raw input.
- **NEVER allocate new Vector3 arrays inside fast path-following loops** — This triggers the garbage collector. Use `PackedVector3Array` to maintain a contiguous memory block.
- **NEVER use dynamic string paths ($"../Checkpoint") in tight loops** — Lookups are slow. Use `@onready` to cache node references during initialization.
- **NEVER record the whole player object for ghosts** — Only record core transforms (position/rotation). Recording the whole object is memory-intensive and unnecessary for visual ghosts.
- **NEVER give the ghost collision** — It should be a purely visual indicator (e.g., semi-transparent) to avoid disrupting the player's line.
- **NEVER neglect checkpoint sequencing** — Don't just check if the player hit the finish line. Verify they passed every intermediate checkpoint in the correct order.
- **NEVER use Area3D without monitoring optimization** — Checkpoints should only look for the `Player` physics layer to minimize the number of physics overlap calculations.
- **NEVER use standard lerp for ghost rotation** — Use `slerp()` or `Quaternion.slerp()` to avoid gimbal lock and ensure smooth rotation interpolation.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
