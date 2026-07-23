# Aurelius Protocol: Genre Party NEVER List

- NEVER hardcode player inputs to specific joypad IDs (e.g., 0 or 1); strictly query dynamically via `Input.get_connected_joypads()`.
- NEVER bake player-IDs into the input map (e.g., "p1_jump"); strictly use a **Dynamic Input Router** to map physical controllers to players at runtime.
- NEVER use `Input.is_action_pressed()` for assigning new player joins; strictly parse raw `InputEventJoypadButton` in `_unhandled_input()` for device metadata.
- NEVER allow inconsistent controls between games; strictly standardize across all minigames (**A = Accept/Action**, **B = Back/Cancel**, **Joystick = Move**).
- NEVER assume a disconnected joypad removes a player; strictly connect to the `joy_connection_changed` signal to pause and handle dropouts gracefully.
- NEVER use boolean polling for analog sticks; strictly use `Input.get_vector()` for precision and deadzones.
- NEVER use long text-based tutorials; strictly use a **3-second looping GIF** + a single-sentence instruction overlay (e.g., "Mash A to fly!").
- NEVER ignore "Asymmetric" balance in 1v3 games; strictly provide the "One" with unique abilities or increased HP/speed to offset the numerical disadvantage.
- NEVER neglect Accessibility and Handicap systems; strictly implement optional support (e.g., speed boosts for lower-skilled players) to keep the competition social.
- NEVER leave UI Control nodes with `FOCUS_NONE` for gamepad menus; strictly set to `FOCUS_ALL` with explicit focus neighbors for accessible navigation.
- NEVER use heavy scene transitions; strictly keep minigame assets light and use **Threaded Background Loading** while the instructions screen is active.
- NEVER draw global `CanvasLayer` UI for individual split-screen players; strictly use per-viewport `CanvasLayer` children.
- NEVER manually set sizes on `SubViewport` children; strictly use `GridContainer` or `BoxContainer` for automatic split-screen layout.
- NEVER store tournament state or scores inside minigame scenes; strictly use a **Persistent Autoload** (Singleton).
- NEVER use a static `Camera2D` for shared-room games; strictly use a **dynamic group camera** that zooms/pans to fit all players in frame.
- NEVER overlap `SubViewportContainer` nodes without setting `mouse_filter` to `PASS`; otherwise, top viewports will block input.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
