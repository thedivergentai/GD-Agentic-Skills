# Aurelius Protocol: Server Architecture NEVER List

- **NEVER trust the client** — Validate all state changes, purchases, and damage exclusively on the authoritative server to prevent cheating [28].
- **NEVER use `TRANSFER_MODE_RELIABLE` for continuous data streams** — Synchronizing coordinates every frame using reliable mode causes extreme network congestion; always use `UNRELIABLE` [29].
- **NEVER use `get_var(true)` on untrusted network packets** — Passing `true` allows the engine to deserialize arbitrary objects, creating a critical Remote Code Execution vulnerability [30].
- **NEVER use TCP for fast-paced action games** — TCP's Nagle's algorithm and congestion control cause unacceptable latency; use Godot's built-in ENet (UDP) [31].
- **NEVER run a dedicated server without stripping visuals** — Always export using "Dedicated Server" mode or use the `Dummy` audio/physics drivers to prevent GPU/CPU waste [32].
- **NEVER expect RPCs to work before connection** — Calling an RPC on a client before the `connected_to_server` signal has fired will fail [34].
- **NEVER assume `UNRELIABLE` packets arrive in order** — UDP packets can arrive out of order or be dropped; design state interpolation to handle missing ticks [31].
- **NEVER leave `SceneTree.multiplayer_poll` set to false without manually calling `poll()`** — Disabling auto-polling without manual polling freezes all network traffic [35].
- **NEVER attempt to connect Godot clients and servers running different engine versions** — The high-level multiplayer API protocol is version-specific and breaking [36].
- **NEVER forget to unbind or free RIDs** — `PhysicsServer3D.body_create()` without `free_rid()` causes massive server-side memory leaks over time.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
