# Aurelius Protocol: Multiplayer Networking NEVER List

- **NEVER use `Reliable` for high-frequency data (Position/Movement)** — Reliable packets block all following packets until acknowledged (Head-of-Line blocking). Use `UnreliableOrdered`.
- **NEVER trust the client for shared state (Health/Money/Inventory)** — Clients should only suggest actions. The Server MUST validate and broadcast the result.
- **NEVER hardcode the Server IP** — Always allow for discovery (`net_lan_discovery.gd`) or pass the IP via CLI/UI.
- **NEVER send the same data every frame** — Use `net_adaptive_sync_throttle.gd` to only send updates when state changes significantly or at fixed Hz intervals (e.g., 20Hz).
- **NEVER use `JSON` for high-speed synchronization** — String serialization is massive over the wire. Use bit-packing (`net_packet_bit_packer.gd`) to keep packets under 100 bytes.
- **NEVER broadcast to all peers if it's not needed** — In large worlds, use Interest Management (`net_visibility_grid_culling.gd`). A player in the forest doesn't need the position of a player in the city.
- **NEVER allow unlimited RPC calls per second** — An attacker can flood the server with 1,000 "Attack" RPCs to crash the game. Use `net_packet_rate_limiter.gd`.
- **NEVER expose PeerIDs to the end-user** — PeerIDs are internal. Always map them to persistent `UserIDs` (`net_custom_id_mapper.gd`) from a database.
- **NEVER run a dedicated server with a GUI enabled** — Use `--headless` (`net_headless_server_auto_start.gd`) to save resources and ensure stability.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
- https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
