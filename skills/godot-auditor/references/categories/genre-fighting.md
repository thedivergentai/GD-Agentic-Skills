# Aurelius Protocol: Genre Fighting NEVER List

- NEVER use variable framerates; strictly lock logic to a **Deterministic Fixed Loop** (using `_physics_process` with a frame-counter) and call **`reset_physics_interpolation()`** on teleport.
- NEVER use standard Physics for hit detection; strictly use **`PhysicsDirectSpaceState.intersect_shape()`** to query hitboxes instantly without Area2D signal lag.
- NEVER skip **Damage Scaling**; strictly apply 10% reduction per hit in a combo to prevent infinite matches.
- NEVER make all moves safe on block; strictly ensure high-reward moves have **Recovery Windows** where the attacker is punishable.
- NEVER rely on `Area2D.get_overlapping_areas()`; strictly use **`intersect_shape()`** for immediate, frame-perfect resolution.
- NEVER forget **Hitbox Proximity (Proximity Guard)**; strictly trigger guard states when a hitbox enters a nearby zone, even if it hasn't landed.
- NEVER use simple parenting (`scale.x = -1`) for character flip; strictly adjust the dedicated **Visuals node** while managing hitbox offsets programmatically.
- NEVER use string-based animation triggers; strictly use `AnimationMixer` with `ADVANCE_MANUAL` for frame-synced playback.
- NEVER use `yield` or `await` for frame-critical logic; strictly use **Integer Frame Counting** within state machines to manage recovery/startup windows perfectly.
- NEVER store frame data in raw scripts; strictly use **`Resource` files (.tres)** with delegated logic for damage scaling, cancels, and combo-state tracking.
- NEVER use deep node hierarchies for character parts; strictly keep skeletons shallow to reduce transformation overhead.
- NEVER skip **Input Buffering**; strictly implement a 5-10 frame buffer to ensure lenient, responsive execution for the player.
- NEVER leave `Input.use_accumulated_input` enabled; strictly disable it to preserve sub-frame timing for precise combo links.
- NEVER use client-side hit detection for netplay; strictly use **rollback netcode** or server validation to prevent desyncs.
- NEVER use standard TCP for multiplayer; strictly use **UDP/ENet** to avoid head-of-line blocking during latency spikes.
- NEVER rely on the SceneTree for fighter transforms in netplay; strictly manage positions in a **serializable data buffer**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
