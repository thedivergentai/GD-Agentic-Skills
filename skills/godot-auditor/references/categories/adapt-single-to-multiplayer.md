# Aurelius Protocol: Adapt Single To Multiplayer NEVER List

- **NEVER trust client-reported state** — Clients own their 'Input', NOT their 'Position' or 'Health'. Server must validate every coordinate and health change.
- **NEVER use `get_tree()` groups for authority checks** — Use `is_multiplayer_authority()`. Group registration is non-deterministic in high-latency joins.
- **NEVER allow unrestricted RPC rates** — A malicious client can call a 'FireWeapon' RPC 10,000 times per second. Always implement rate-limiting (`net_rpc_rate_limiter.gd`).
- **NEVER skip Client-Side Prediction** — Movement without prediction feels 'heavy' and unresponsive. Predict movement locally, then correct only on server disagreement.
- **NEVER sync peers at 60Hz** — Sending entire state every frame will saturate client bandwidth. Use a lower tick-rate (20-30Hz) and interpolate between packets.
- **NEVER snap peer positions** — Abrupt position updates cause 'jitter'. Store a buffer of past states and lerp between them with a 100ms delay.
- **NEVER sync 'Full Floats' if possible** — Quantize Vector3 data (truncating decimals) to save 50%+ bandwidth. Use `MultiplayerSynchronizer` with delta-sync enabled.
- **NEVER ignore 'Late Joiners'** — Players who join mid-game won't see existing environmental changes. Broadcast a full world-state 'Snapshot' on peer connection.
- **NEVER test on 0ms ping** — Everything works on localhost. Use a simulator (`net_latency_simulator.gd`) with 150ms ping to identify sync bugs.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
