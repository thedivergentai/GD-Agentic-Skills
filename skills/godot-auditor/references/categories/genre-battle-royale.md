# Aurelius Protocol: Genre Battle Royale NEVER List

- NEVER sync all 100 players every frame; strictly use a **Relevancy System** to sync high-freq data only for players within ~100m. Far players sync at ~5Hz.
- NEVER use `TRANSFER_MODE_RELIABLE` for movement data; strictly use **Unreliable** to prevent packet backup and network congestion.
- NEVER focus on client-side hit detection; strictly use **Authoritative Server Validation** where the server confirms "Did it hit?" based on state history.
- NEVER trust the client for game state; strictly validate all movement, looting, and inventory changes exclusively on the authoritative server.
- NEVER run a dedicated server with visuals; strictly use **Headless Mode** (`--headless`) or dummy drivers to save massive CPU/GPU resources.
- NEVER call RPCs before connection; strictly wait for the `connected_to_server` signal before attempting synchronization logic.
- NEVER pick a fully random center for the Safe Zone; strictly target centers that ensure the new circle is **completely contained** within the current one.
- NEVER allow "Storm Tunneling"; strictly use a **Distance-to-Center** calculation rather than a simple collision perimeter to prevent skips at low tick rates.
- NEVER spawn loot without **Object Pooling**; strictly pre-instantiate and toggle visibility/collision to avoid GC spikes during dense spawns.
- NEVER ignore `VisibilityNotifier3D`; strictly disable `AnimationPlayer`, `_process()`, and heavy AI logic for players that are not visible to the observer.
- NEVER print in tight server loops; strictly avoid `print()` as console I/O is blocking and will tank server performance in high-player-count matches.
- **NEVER export mobile clients without the INTERNET permission** — Communication will silently fail on Android/iOS if the manifest is missing the networking permission [37].
- **NEVER use `get_var(true)` on untrusted data** — Deserializing arbitrary objects allows attackers to execute remote code on the server or other clients [31].
- **NEVER synchronize `Object` or `Resource` types over network** — Use the `MultiplayerSynchronizer` strictly for base types (int, float, vec) [39].
- **NEVER assume `UNRELIABLE` packets arrive in order** — Design state interpolation carefully to handle missing or out-of-order ticks [28].
- **NEVER leave `multiplayer_poll` false without manual calling** — If using custom threads, failing to call `multiplayer.poll()` freezes all traffic [40].
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
