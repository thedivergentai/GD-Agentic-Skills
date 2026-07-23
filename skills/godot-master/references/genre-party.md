---
name: godot-genre-party
description: "Expert blueprint for party games including minigame resource system (define via .tres files), local multiplayer input (4-player controller management), asymmetric gameplay (1v3 balance), scene management (clean minigame loading/unloading), persistent scoring (track wins across rounds), and split-screen rendering (SubViewport per player). Use for Mario Party-style games or WarioWare collections. Trigger keywords: party_game, minigame_collection, local_multiplayer, asymmetric_gameplay, split_screen, dynamic_input_mapping."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Party / Minigame Collection

Expert blueprint for party games balancing accessibility, variety, and social fun.

## NEVER Do (Expert Anti-Patterns)

### Multiplayer & Input
- NEVER hardcode player inputs to specific joypad IDs (e.g., 0 or 1); strictly query dynamically via `Input.get_connected_joypads()`.
- NEVER bake player-IDs into the input map (e.g., "p1_jump"); strictly use a **Dynamic Input Router** to map physical controllers to players at runtime.
- NEVER use `Input.is_action_pressed()` for assigning new player joins; strictly parse raw `InputEventJoypadButton` in `_unhandled_input()` for device metadata.
- NEVER allow inconsistent controls between games; strictly standardize across all minigames (**A = Accept/Action**, **B = Back/Cancel**, **Joystick = Move**).
- NEVER assume a disconnected joypad removes a player; strictly connect to the `joy_connection_changed` signal to pause and handle dropouts gracefully.
- NEVER use boolean polling for analog sticks; strictly use `Input.get_vector()` for precision and deadzones.

### User Experience & Feedback
- NEVER use long text-based tutorials; strictly use a **3-second looping GIF** + a single-sentence instruction overlay (e.g., "Mash A to fly!").
- NEVER ignore "Asymmetric" balance in 1v3 games; strictly provide the "One" with unique abilities or increased HP/speed to offset the numerical disadvantage.
- NEVER neglect Accessibility and Handicap systems; strictly implement optional support (e.g., speed boosts for lower-skilled players) to keep the competition social.
- NEVER leave UI Control nodes with `FOCUS_NONE` for gamepad menus; strictly set to `FOCUS_ALL` with explicit focus neighbors for accessible navigation.

### Rendering & Architecture
- NEVER use heavy scene transitions; strictly keep minigame assets light and use **Threaded Background Loading** while the instructions screen is active.
- NEVER draw global `CanvasLayer` UI for individual split-screen players; strictly use per-viewport `CanvasLayer` children.
- NEVER manually set sizes on `SubViewport` children; strictly use `GridContainer` or `BoxContainer` for automatic split-screen layout.
- NEVER store tournament state or scores inside minigame scenes; strictly use a **Persistent Autoload** (Singleton).
- NEVER use a static `Camera2D` for shared-room games; strictly use a **dynamic group camera** that zooms/pans to fit all players in frame.
- NEVER overlap `SubViewportContainer` nodes without setting `mouse_filter` to `PASS`; otherwise, top viewports will block input.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [party_input_router.gd](../scripts/genre_party_party_input_router.gd) — lobby join + device→player routing (golden path)
> 2. [minigame_orchestrator.gd](../scripts/genre_party_minigame_orchestrator.gd) — hub ↔ minigame scene cycle
> 3. [connection_monitor.gd](../scripts/genre_party_connection_monitor.gd) — joy disconnect pause / reconnect

### Original Expert Patterns
- [party_input_router.gd](../scripts/genre_party_party_input_router.gd) - Device-ID join + `pN_*` InputMap routing (complete, not a stub).

### Modular Components
- [minigame_orchestrator.gd](../scripts/genre_party_minigame_orchestrator.gd) - Autoload-style minigame sequencing.
- [minigame_async_loader.gd](../scripts/genre_party_minigame_async_loader.gd) - Threaded PackedScene load during instruction screens.
- [split_screen_setup.gd](../scripts/genre_party_split_screen_setup.gd) - 2–4 SubViewportContainer grid.
- [split_screen_manager.gd](../scripts/genre_party_split_screen_manager.gd) - Viewport sync / shared world helpers.
- [local_input_manager.gd](../scripts/genre_party_local_input_manager.gd) - Runtime InputMap remaps for 4+ pads.
- [connection_monitor.gd](../scripts/genre_party_connection_monitor.gd) - `joy_connection_changed` pause + reconnect UI group.
- [player_join_manager.gd](../scripts/genre_party_player_join_manager.gd) - Slot mapping from raw JoypadButton events.
- [deferred_scene_switcher.gd](../scripts/genre_party_deferred_scene_switcher.gd) - Safe deferred free/instantiate.
- [tournament_state.gd](../scripts/genre_party_tournament_state.gd) - Persistent scores / roster Autoload.
- [character_select_grid.gd](../scripts/genre_party_character_select_grid.gd) - Focus-safe character select.
- [minigame_player_controller.gd](../scripts/genre_party_minigame_player_controller.gd) - Per-player pawn bound to routed actions.
- [player_haptic_feedback.gd](../scripts/genre_party_player_haptic_feedback.gd) - Per-device rumble.
- [shared_party_camera.gd](../scripts/genre_party_shared_party_camera.gd) - Shared-camera minigames (non-split).

---

## Core Loop
1. **Lobby join** → 2. **Meta/board** → 3. **Minigame** → 4. **Score** → 5. **Repeat**

## Decision Trees

### Input & dropout
| Need | Action |
|------|--------|
| Lobby join + route | **MANDATORY** [party_input_router.gd](../scripts/genre_party_party_input_router.gd) |
| Runtime `pN_*` remaps | [local_input_manager.gd](../scripts/genre_party_local_input_manager.gd) |
| Pad battery death mid-game | **MANDATORY** [connection_monitor.gd](../scripts/genre_party_connection_monitor.gd) — pause tree + reconnect overlay |

### Scenes & viewports
| Need | Action |
|------|--------|
| Cycle minigames | **MANDATORY** [minigame_orchestrator.gd](../scripts/genre_party_minigame_orchestrator.gd) (+ [deferred_scene_switcher.gd](../scripts/genre_party_deferred_scene_switcher.gd)) |
| Prefetch during how-to | [minigame_async_loader.gd](../scripts/genre_party_minigame_async_loader.gd) |
| 2–4 split | [split_screen_setup.gd](../scripts/genre_party_split_screen_setup.gd) — per-viewport CanvasLayer; `mouse_filter` on containers |
| Shared camera party | [shared_party_camera.gd](../scripts/genre_party_shared_party_camera.gd) |

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Input | `godot-input-handling` | 2–4 local controllers |
| 2. Scene | `godot-scene-management` | Load/unload minigames |
| 3. Data | `godot-resource-data-patterns` | Minigame `.tres` defs |
| 4. UI | `godot-ui-containers` | Lobby / score / reconnect |
| 5. Balance | `godot-monte-carlo-balancer` | Asymmetric 1v3 power |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Shared `jump` action | Device-bound `pN_*` via router / local_input_manager |
| Global CanvasLayer in split | Per-SubViewport UI layers |
| Generic screen-shake Elite | Prefer split + reconnect procedures above |

## Split-screen + reconnect procedure
1. Build viewports with [split_screen_setup.gd](../scripts/genre_party_split_screen_setup.gd).
2. Bind devices through [party_input_router.gd](../scripts/genre_party_party_input_router.gd) before the minigame starts.
3. Keep [connection_monitor.gd](../scripts/genre_party_connection_monitor.gd) alive as Autoload; on disconnect pause and `call_group("ui_overlays", "show_reconnect", device)`.
4. On reconnect, re-bind the same `player_id` → new `device_id` then unpause — do not remap other players.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Joypad connect/disconnect, device IDs, and multi-pad mapping for lobby join and local isolation.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event order and `_unhandled_input` so join presses and per-device routing run after UI focus.
- [Controller vibration and features](https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html) — Per-device rumble APIs used for localized hit/eliminate feedback.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — SubViewport worlds, cameras, and UI layers required for 2–4 player split-screen.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader` threaded load while the instructions screen stays interactive.
- [Change scenes manually](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html) — Deferred free/instantiate patterns for hub ↔ minigame swaps without mid-frame crashes.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Persistent tournament scores, device maps, and party roster across scene changes.
- [GUI navigation](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html) — Focus neighbors and gamepad menu traversal for character select and lobby UI.
- [Pausing games](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html) — Tree pause + reconnect overlays when a joypad drops mid-minigame.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — `.tres` minigame definitions (title, scene path, 1v3 flags) without hardcoding catalogs.
- [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) — Runtime `action_add_event` for per-player device-bound actions (`pN_*`).

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Device IDs, `InputMap` remaps, deadzones, and `_unhandled_input` ownership before party routing.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Clean load/unload and deferred scene swaps between hub, instructions, and minigames.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Typed `Resource` / `.tres` catalogs that define each minigame's scene and metadata.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton placement for tournament state that must outlive every minigame scene.

#### Complements
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Scoreboards, instruction overlays, and `GridContainer` split-screen / character-select layouts with focus.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Shared-room framing and per-viewport cameras that zoom/pan to keep all players on screen.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `player_joined`, `game_ended`, and reconnect prompts without hard refs across lobby and minigames.
- [godot-turn-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md) — Board / meta round phases between short competitive minigames.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Short stingers, countdown cues, and per-player SFX buses that survive rapid scene cycling.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate asymmetric 1v3 / handicap power offsets so party roles stay socially fair across rounds.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Typical consumer of per-device move vectors inside shared-screen 2D party arenas.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns input, scenes, or UI pieces of a party stack.
