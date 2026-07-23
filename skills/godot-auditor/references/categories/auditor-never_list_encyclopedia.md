# Aurelius Protocol: Auditor Never_List_Encyclopedia NEVER List

- **NEVER**: Call `RenderingServer.mesh_create()`, `PhysicsServer3D.shape_create()`, or `RenderingDevice.texture_buffer_create()` without a corresponding `free_rid()` call.
- **NEVER**: Create a circular reference between two `RefCounted` or `Resource` objects without at least one being a `WeakRef`.
- **Expert Rationale**: Godot's ref-counter cannot resolve local cycles. Two resources pointing to each other will never reach zero count and will leak indefinitely.
- **NEVER**: Acquire a `Mutex.lock()` inside a high-frequency loop (e.g., `for i in 10000`).
- **NEVER**: Call `RenderingServer.texture_get_data()` or `RenderingDevice.buffer_get_data()` inside `_process` or `_physics_process`.
- **NEVER**: Re-assign `texture` or `material` properties on a per-instance basis inside a hot loop for 2D sprites.
- **NEVER**: Use a `Sprite2D` for a massive static background (e.g., 2048x2048) if 70% of the image is transparent.
- **NEVER**: Use `get_parent().some_method()` or `get_node("../../Other")`.
- **NEVER**: Use an `AutoLoad` singleton to track transient gameplay nodes (e.g., `Globals.current_player = self`).
- **NEVER**: Use `get_var(true)` on data received via `PacketPeer` or `StreamPeer`.
- **NEVER**: Enable `allow_object_decoding = true` on the `MultiplayerAPI` for public servers.
- **NEVER**: Reference a file with mismatched casing (e.g., `res://Player.png` when the file is `player.png`).
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
