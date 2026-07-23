---
name: godot-input-handling
description: "Expert patterns for input handling covering InputMap actions, InputEvent processing, controller support, rebinding, deadzones, and input buffering. Use when setting up player controls, implementing input systems, or adding gamepad/accessibility features. Keywords InputMap, InputEvent, gamepad, controller, rebinding, deadzone, input buffer."
---

# Input Handling

Handle keyboard, mouse, gamepad, and touch input with proper buffering and accessibility support.

## MANDATORY script triggers (by scenario)

| Scenario | Load before coding |
|----------|--------------------|
| Jump/dash/coyote feel | [input_buffer.gd](../scripts/input_handling_input_buffer.gd) (physics-tied decay) + [advanced_input_buffer.gd](../scripts/input_handling_advanced_input_buffer.gd) for multi-action priority |
| Settings remapping UI | [safe_runtime_rebind.gd](../scripts/input_handling_safe_runtime_rebind.gd) (`ConfigFile` persist to `user://`) |
| Analog stick movement | [analog_deadzone_manager.gd](../scripts/input_handling_analog_deadzone_manager.gd) — never raw axis without radial deadzone |
| "Press X / Press E" prompts | [glyph_prompt_manager.gd](../scripts/input_handling_glyph_prompt_manager.gd) |
| UI nav vs gameplay confirm | [input_echo_filter.gd](../scripts/input_handling_input_echo_filter.gd) — echoes move menus, not Confirm/Back |
| Gameplay vs menu clicks | [unhandled_input_priority.gd](../scripts/input_handling_unhandled_input_priority.gd) |


## Do-NOT-Load (by scenario)

| Scenario | Load | Do NOT load |
|----------|------|-------------|
| Settings remapping UI | `safe_runtime_rebind.gd` | `multi_touch_gestures.gd`, `mouse_capture_manager.gd`, combo/replay injectors |
| Mobile / touch gestures | `multi_touch_gestures.gd` | `mouse_capture_manager.gd`, desktop remapper persistence |
| Jump/dash buffer only | `input_buffer.gd` / `advanced_input_buffer.gd` | Remapper, multi-touch, replay, combo validator |
| FPS mouse look | `mouse_capture_manager.gd` + deadzone/glyph as needed | `multi_touch_gestures.gd`, combo/replay |
| Combo / fighting sequences | `combo_validator.gd` + buffers | Touch gestures, mouse capture |
| Replay / virtual injection tests | `input_replay_buffer.gd` / `virtual_input_injector.gd` | Remapper UI, multi-touch |

## Available Scripts

### [advanced_input_buffer.gd](../scripts/input_handling_advanced_input_buffer.gd)
Frame-perfect input buffering system for responsive jumps, dashes, and combo chains.

### [input_buffer.gd](../scripts/input_handling_input_buffer.gd)
Timed action buffer with **`_physics_process` decay** so windows match CharacterBody consumption, not render FPS.

### [safe_runtime_rebind.gd](../scripts/input_handling_safe_runtime_rebind.gd)
Dynamic input rebinding with conflict detection and `user://input_rebinds.cfg` persistence.

### [analog_deadzone_manager.gd](../scripts/input_handling_analog_deadzone_manager.gd)
Radial deadzone management for analog sticks to eliminate drift while maintaining natural follow-through.

### [multi_touch_gestures.gd](../scripts/input_handling_multi_touch_gestures.gd)
Handling touch, drags, and pinch-to-zoom gestures for mobile and touchscreen compatibility.

### [input_echo_filter.gd](../scripts/input_handling_input_echo_filter.gd)
Filtering echo events to distinguish between hold-to-navigate (UI) and one-time gameplay actions.

### [mouse_capture_manager.gd](../scripts/input_handling_mouse_capture_manager.gd)
Robust mouse capture and sensitivity scaling logic for FPS and mouse-intensive systems.

### [hold_toggle_accessibility.gd](../scripts/input_handling_hold_toggle_accessibility.gd)
Software-side support for user-defined 'Hold' vs 'Toggle' accessibility preferences.

### [glyph_prompt_manager.gd](../scripts/input_handling_glyph_prompt_manager.gd)
Real-time switching between Keyboard and Gamepad UI prompts based on the last active device.

### [action_state_machine.gd](../scripts/input_handling_action_state_machine.gd)
Tracking the lifecycle of an action ('Just Pressed', 'Held', 'Released') for complex state logic.

### [unhandled_input_priority.gd](../scripts/input_handling_unhandled_input_priority.gd)
Demonstrating the correct use of `_unhandled_input` to prevent gameplay logic from leaking into UI.


### [virtual_input_injector.gd](../scripts/input_handling_virtual_input_injector.gd)
`Input.parse_input_event` injection for CI tutorials / AI assistance — not physical hardware.

### [combo_validator.gd](../scripts/input_handling_combo_validator.gd)
Rolling timed sequence buffer for special-move validation (fighting / action RPG).

### [input_replay_buffer.gd](../scripts/input_handling_input_replay_buffer.gd)
Frame-tagged capture + deterministic replay via `parse_input_event`.

## NEVER Do in Input Handling

- **NEVER poll input in `_process()` for gameplay actions** — Use `_physics_process()` or `_unhandled_input()`. `_process()` is frame-rate dependent, causing dropped inputs at low FPS [22].
- **NEVER use hardcoded key checks (e.g., `KEY_W`)** — Always use `InputMap` actions. Hardcoded keys prevent rebinding and break compatibility with non-QWERTY layouts [23].
- **NEVER ignore analog stick deadzones** — Drifting sticks at 0.05 magnitude will cause unintended movement. Implement a radial deadzone (not axial) in code or settings [24].
- **NEVER assume a single input device** — Players may switch between Keyboard and Controller mid-session. Use `Input.joy_connection_changed` to update UI prompts dynamically [25].
- **NEVER use `_input()` for gameplay actions** — `_input()` fires for ALL events (including UI). Use `_unhandled_input()` so gameplay logic doesn't trigger while clicking menus [26].
- **NEVER omit input buffering in fast-paced games** — If a player presses jump 50ms before landing, the input is lost without a buffer. Implement a 100-150ms buffer for a "tight" feel [27].
- **NEVER use `Input.is_action_pressed()` for one-time triggers** — It returns true every frame the key is held. Use `_just_pressed` for jumps, attacks, and toggles to avoid logic spam.
- **NEVER implement manual 'Hold vs Toggle' logic in multiple places** — Centralize it in a setting or input wrapper to ensure accessibility consistency across the whole game.
- **NEVER forget to handle `InputEvent.is_echo()` in UI navigation** — Echo events (keyboard repeat) should move menus but rarely should they trigger "Confirm" or "Back" actions.
- **NEVER capture the mouse without a 'Release' shortcut** — If your game crashes or blocks `ui_cancel`, the user is trapped. Always provide a fallback escape for mouse capture.

---

## Godot 4.7: Input Device IDs

- Mouse and keyboard are no longer device ID `0` — use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD`.
- **NEVER** compare `event.device == 0` for mouse/keyboard; joypads may legitimately use ID 0.

## Input Propagation & Isolation
Godot propagates input events in a specific order. Understanding this is key to isolating UI from gameplay.

1. **`_input(event)`**: High-priority global intercept. Use for dev consoles or debug overlays.
2. **`_gui_input(event)`**: Handled by **Control nodes (UI)**. If a UI element consumes the event (e.g., clicking a button), it calls `accept_event()`, stopping further propagation.
3. **`_unhandled_input(event)`**: Reached ONLY if no UI element consumed the event. **Expert Pattern**: Put all gameplay logic (jump, shoot) here to prevent accidental triggers while interacting with menus.

## InputMap Best Practices
Avoid physical key checks. Define semantic actions (e.g., `move_left`, `interact`) in **Project Settings > Input Map**.

### 1. Analog Deadzones
Analog sticks suffer from drift. **MANDATORY**: [analog_deadzone_manager.gd](../scripts/input_handling_analog_deadzone_manager.gd). Prefer `Input.get_vector()` for circular deadzones — never subtract axes into a square deadzone.

### 2. Expert polling delta (no hardcoded keys)
Gameplay samples **actions** in `_physics_process` / `_unhandled_input` — never `KEY_*` / `MOUSE_BUTTON_*` branches. Pause/cancel must be InputMap actions (e.g. `ui_cancel`) so rebinds and non-QWERTY layouts work. See [unhandled_input_priority.gd](../scripts/input_handling_unhandled_input_priority.gd).

## Multi-Modal Input & UI Glyphs
Modern games must handle simultaneous Controller and Keyboard/Mouse input smoothly.

### 1. Handling Input Modes
- **Mouse Aiming**: Process `InputEventMouseMotion` in `_unhandled_input()` for relative movement ([mouse_capture_manager.gd](../scripts/input_handling_mouse_capture_manager.gd)).
- **Stick Movement**: Poll vectors in `_physics_process()` after [analog_deadzone_manager.gd](../scripts/input_handling_analog_deadzone_manager.gd).

### 2. Dynamic Glyph Swapping
**MANDATORY**: [glyph_prompt_manager.gd](../scripts/input_handling_glyph_prompt_manager.gd) for last-device prompt swaps. Do not hand-roll `event is InputEventJoypadButton` detectors in every HUD widget.

## Expert Input Extensions (script sole-source)

- **Input buffering** — **MANDATORY**: [input_buffer.gd](../scripts/input_handling_input_buffer.gd) + [advanced_input_buffer.gd](../scripts/input_handling_advanced_input_buffer.gd). Do not paste jump-timer tutorials inline.
- **Coyote time** — Owned by movement skills: [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) (`frame_perfect_coyote_time.gd`) and [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md). Pair with buffers from this skill; do not re-implement coyote here.
- **Multiplayer input sync** — **Do not RPC `sync_input` here.** Route to [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) for authoritative action snapshots / `get_remote_sender_id` validation.
- **Virtual injection** — **MANDATORY**: [virtual_input_injector.gd](../scripts/input_handling_virtual_input_injector.gd) (`Input.parse_input_event`).
- **Combo sequences** — **MANDATORY**: [combo_validator.gd](../scripts/input_handling_combo_validator.gd); fighting fiction stays in `godot-genre-fighting`.
- **Deterministic replay** — **MANDATORY**: [input_replay_buffer.gd](../scripts/input_handling_input_replay_buffer.gd).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event propagation order (`_input` → GUI → `_unhandled_input`) and why gameplay belongs after UI consumes events.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Practical `InputMap` action polling, mouse buttons, and keyboard patterns this skill builds on.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Joypad connection, button/axis events, and multi-device mapping for remappers and glyph swaps.
- [Controller vibration and features](https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html) — Extended pad capabilities beyond basic buttons when shipping console-style feedback.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Viewport vs screen coordinates for clicks, aim, and capture-relative motion.
- [Customizing the mouse cursor](https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html) — Cursor shapes alongside `Input.mouse_mode` capture/release flows.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — Safe ESC / back / quit paths so mouse capture never traps the player.
- [Input](https://docs.godotengine.org/en/stable/classes/class_input.html) — Singleton API: `is_action_*`, `get_vector`, `mouse_mode`, `parse_input_event`, and joy connection signals.
- [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) — Runtime `action_add_event` / erase / conflict checks for safe rebinding.
- [InputEvent](https://docs.godotengine.org/en/stable/classes/class_inputevent.html) — Base event API including `is_echo()`, `is_action_pressed()`, and device IDs.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Why hold/poll gameplay input in `_physics_process`, not frame-tied `_process`.
- [Control](https://docs.godotengine.org/en/stable/classes/class_control.html) — `_gui_input` / `accept_event` so menus stop events before `_unhandled_input` gameplay.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project Settings Input Map, scene boot, and Autoload registration that host remappers and glyph managers.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed `InputEvent` branches, `StringName` actions, and safe signal/`await` patterns used in buffers and device routers.

#### Complements
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Control focus and `_gui_input` ownership so menus consume clicks before gameplay `_unhandled_input`.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `device_changed` and rebind events should signal up to HUD/prompt listeners without hard UI refs.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton ownership for InputBuffer / GlyphPrompt / Remapper services that survive scene changes.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Consumes buffered jump/dash and `get_vector` movement inside physics steps.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Mouse-look sensitivity and capture modes pair with FPS camera rigs.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Action just-pressed / held / released phases drive FSM transitions without polling spam.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist `InputMap` rebinds and hold/toggle accessibility prefs to `user://` config.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Virtual joysticks and touch cameras extend this skill’s multi-touch gesture patterns.

#### Downstream / consumers
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — Coyote time and jump buffers are the primary consumer of input buffering.
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — Captured mouse aim, fire just-pressed, and gamepad look rely on this skill’s capture/deadzone stack.
- [godot-genre-fighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md) — Combo sequence validators and frame-perfect buffers feed special-move detection.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Authoritative peers need sanitized action snapshots / RPC’d input, not raw local keycodes.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting input concern.
