# Aurelius Protocol: Platform Console NEVER List

- **NEVER show a mouse cursor** — Showing a cursor on a console is a certification (TRC/TCR) failure. Hide it using `Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)`.
- **NEVER skip pausing on focus loss** — If a player presses the Home button and the game keeps running, it's a certification violation. Monitor `NOTIFICATION_APPLICATION_FOCUS_OUT` and force a pause.
- **NEVER use an unlocked frame rate** — Variable FPS leads to screen tearing and rejections. Lock specifically to 30 or 60 FPS using `Engine.max_fps` and enable VSync.
- **NEVER forget D-Pad navigation** — UI that is only navigable with an analog stick is an accessibility failure. Always support D-Pad inputs for all menu interactions.
- **NEVER hardcode button labels** — Displaying "Press A" on a PlayStation controller is a major mistake. Use `Input.get_joy_button_string()` or dynamic icon mapping based on the controller's GUID.
- **NEVER exceed hardware memory limits** — Consoles (especially Switch) have very rigid RAM budgets. Exceeding them causes OS-level crashes. Profile strictly using the memory tab in the Godot Profiler.
- **NEVER assume Joypad 0 is always Player 1** — Users may connect controllers in any order. Always query active connections dynamically using `Input.get_connected_joypads()`.
- **NEVER distribute console export templates or SDKs publicly** — Console SDKs are strictly under Non-Disclosure Agreements (NDAs). Leaking these can lead to legal action and developer banishment.
- **NEVER handle continuous analog stick input using boolean checks** — Using `is_action_pressed()` for sticks ignores deadzones and precision. Use `get_vector()` or `get_action_strength()` for smooth movement.
- **NEVER vibrate controllers continuously without an option to disable it** — Always use `Input.start_joy_vibration()` with finite durations and provide an accessibility toggle to turn off haptics.
- **NEVER expect traditional OS window manipulation to function on consoles** — Consoles operate in fixed fullscreen environments. Methods like `DisplayServer.window_set_mode()` will typically fail or be ignored.
- **NEVER map UI interactions manually to raw button indices** — Always utilize the Project Input Map (u_accept, u_cancel). This allows Godot to dynamically route gamepad events regardless of the specific hardware.
- **NEVER rely on NOTIFICATION_WM_CLOSE_REQUEST for termination** — Consoles often use background suspension (similar to mobile) rather than explicit window closing.
- **NEVER query inputs without flushing buffered events for frame-perfect logic** — Use `Input.flush_buffered_events()` before critical checks to ensure responsiveness.
- **NEVER use == or != to evaluate analog trigger axes** — Floating-point precision loss makes exact equality comparison unreliable. Use `is_equal_approx()` for analog values.
- **NEVER leave orphaned nodes in memory during scene transitions** — Strict RAM limits mandate aggressive cleanup. Always use `queue_free()` and avoid cyclic references that prevent garbage collection.
- **NEVER show a mouse cursor** — Rejection (TRC/TCR) failure. Hide using `Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)`.
- **NEVER skip pausing on focus loss** — Rejection violation. Monitor `NOTIFICATION_APPLICATION_FOCUS_OUT`.
- **NEVER let a controller disconnect go unhandled** — Must force pause and show "Reconnect Controller" UI.
- **NEVER use an unlocked frame rate** — Leads to tearing and instability. Lock specifically (30/60) using `Engine.max_fps`.
- **NEVER exceed hardware memory limits** — Switch has rigid RAM budgets. Monitor via `OS.get_static_memory_usage()`.
- **NEVER ignore VSync** — Console displays expect VSync. Always enable in `DisplayServer`.
- **NEVER assume Joypad 0 is Player 1** — Users switch slots. Query `Input.get_connected_joypads()` dynamically.
- **NEVER write to `res://` at runtime** — Rejection failure. Exported binaries are read-only. Strictly use `user://`.
- **NEVER save synchronously** — Main-thread stutters trigger TCR warnings. Offload to `WorkerThreadPool`.
- **NEVER skip atomic renames for saves** — Power loss mid-save must not corrupt data. Write to `.tmp` then rename.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
