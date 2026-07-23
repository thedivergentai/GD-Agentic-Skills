---
name: godot-platform-console
description: "Expert blueprint for console platforms (PlayStation, Xbox, Nintendo Switch) covering controller-first UI, certification requirements (TRCs/TCRs), platform services (achievements, cloud saves), and performance compliance. Use when targeting console releases or implementing gamepad-only interfaces. Keywords console, PlayStation, Xbox, Switch, TRC, TCR, certification, controller, gamepad, achievements."
---

# Platform: Console

Controller-first design, certification compliance, and locked frame rates define console development.

## NEVER Do

- **NEVER show a mouse cursor** — Certification (TRC/TCR) failure. Hide with `Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)`.
- **NEVER skip pausing on focus loss** — Monitor `NOTIFICATION_APPLICATION_FOCUS_OUT` and force a pause.
- **NEVER let a controller disconnect go unhandled** — Force pause and show reconnect UI.
- **NEVER use an unlocked frame rate** — Lock 30 or 60 FPS via `Engine.max_fps` and enable VSync.
- **NEVER forget D-Pad navigation** — Analog-only menus fail accessibility/TRC. Support D-Pad for all menus.
- **NEVER hardcode button labels** — Use GUID-based prompt mapping (`controller_prompt_mapper.gd`), not "Press A".
- **NEVER exceed hardware memory limits** — Profile RAM; Switch budgets are rigid.
- **NEVER assume Joypad 0 is always Player 1** — Query `Input.get_connected_joypads()`.
- **NEVER distribute console export templates or SDKs publicly** — NDA-bound.
- **NEVER handle continuous analog sticks with boolean checks** — Use `get_vector()` / `get_action_strength()`.
- **NEVER vibrate continuously without a disable option** — Finite `Input.start_joy_vibration()` + accessibility toggle.
- **NEVER expect OS window APIs on consoles** — `DisplayServer.window_set_mode()` is ignored/fails.
- **NEVER map UI to raw button indices** — Use Project Input Map (`ui_accept`, `ui_cancel`, custom actions).
- **NEVER rely on `NOTIFICATION_WM_CLOSE_REQUEST` for termination** — Consoles suspend; handle focus/suspend paths.
- **NEVER query inputs without flushing when frame-perfect** — `Input.flush_buffered_events()` before critical checks.
- **NEVER use `==` / `!=` on analog trigger axes** — Use `is_equal_approx()`.
- **NEVER leave orphaned nodes across scene transitions** — Strict RAM; `queue_free()` and break cycles.
- **NEVER write to `res://` at runtime** — Use `user://` only.
- **NEVER save synchronously on the main thread** — Offload; atomic `.tmp` then rename.

---

## Godot 4.7: Console Input

- Use `InputEvent.DEVICE_ID_*` constants — never assume device `0` is mouse/keyboard.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [certification_manager.gd](scripts/certification_manager.gd)
Expert TRC/TCR compliance (focus loss, controller disconnects).

### [performance_scaler_fsr.gd](scripts/performance_scaler_fsr.gd)
Dynamic Resolution Scaling and FSR 2.2 management for console performance.

### [server_side_projectile.gd](scripts/server_side_projectile.gd)
Direct RenderingServer/PhysicsServer bypass for high-frequency objects.

### [async_save_manager.gd](scripts/async_save_manager.gd)
Atomic, corruption-resistant threaded save system.

### [controller_prompt_mapper.gd](scripts/controller_prompt_mapper.gd)
GUID-based button prompt detection (PlayStation/Xbox/Switch).

### [memory_budget_guard.gd](scripts/memory_budget_guard.gd)
Strict RAM monitoring for platform-specific hardware budgets.

### [platform_dialog_invoker.gd](scripts/platform_dialog_invoker.gd)
Native OS dialog and virtual keyboard abstraction.

### [background_data_prefetcher.gd](scripts/background_data_prefetcher.gd)
Asset pre-fetching using WorkerThreadPool to avoid level-load stutters.

### [achievement_offline_queue.gd](scripts/achievement_offline_queue.gd)
Achievement/Trophy caching with offline persistence.

### [console_boot_config.gd](scripts/console_boot_config.gd)
Hardware-aware hardware initialization and rendering overrides.

---

## Certification Golden Path (MANDATORY scripts)

Run this checklist in order for a console-ready vertical slice. **Do NOT Load** optional scripts unless the row below says optional.

| Step | MANDATORY script | Do NOT Load (unless needed) |
| :--- | :--- | :--- |
| 1. Boot | [console_boot_config.gd](scripts/console_boot_config.gd) | [server_side_projectile.gd](scripts/server_side_projectile.gd) — RID bypass, not cert |
| 2. Focus / disconnect | [certification_manager.gd](scripts/certification_manager.gd) | — |
| 3. Save atomicity | [async_save_manager.gd](scripts/async_save_manager.gd) | — |
| 4. FPS / scaler / RAM | [performance_scaler_fsr.gd](scripts/performance_scaler_fsr.gd) + [memory_budget_guard.gd](scripts/memory_budget_guard.gd) | Switch: set `ram_limit_mb` ≈ **3072** (retail) / warn at **3584**; PS/Xbox: **4096–5120** per SKU — see script `@export` |
| 5. Prompts | [controller_prompt_mapper.gd](scripts/controller_prompt_mapper.gd) | — |

**Optional only:** [achievement_offline_queue.gd](scripts/achievement_offline_queue.gd), [platform_dialog_invoker.gd](scripts/platform_dialog_invoker.gd), [background_data_prefetcher.gd](scripts/background_data_prefetcher.gd). **Do NOT Load** these during steps 1–5 unless achievements, system dialogs, or prefetch are in scope.

## Input Handling (Input Map — not raw indices)

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        on_confirm()
    elif event.is_action_pressed("ui_cancel"):
        on_cancel()
    # Prompts: MANDATORY controller_prompt_mapper.gd for face-button glyphs
```

## Expert Techniques

### TRC failure → fix (symptom → script → doc)

| Symptom | Fix script | Doc |
| :--- | :--- | :--- |
| Mouse pointer visible in game UI | Hide via Input Map flow + `Input.MOUSE_MODE_HIDDEN` in boot | [Custom mouse cursor](https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html) |
| Game runs when dashboard/home pressed | [certification_manager.gd](scripts/certification_manager.gd) focus-out pause | [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) |
| "Press A" hardcoded on Switch | [controller_prompt_mapper.gd](scripts/controller_prompt_mapper.gd) GUID glyphs | [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) |
| Save corruption on power loss | [async_save_manager.gd](scripts/async_save_manager.gd) `.tmp` rename | [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) |
| Frame time spikes / TRC perf fail | [performance_scaler_fsr.gd](scripts/performance_scaler_fsr.gd) + RAM guard | [Resolution scaling](https://docs.godotengine.org/en/stable/tutorials/3d/resolution_scaling.html) |

### 1. Platform-Overlay-Manager (Native UI Dialogs)
Prefer [platform_dialog_invoker.gd](scripts/platform_dialog_invoker.gd) / `DisplayServer.dialog_show()` for TRC system messages over custom modal stacks.

### 2. Shader-Binary-Caching (RenderingDevice)
Enable shader/pipeline cache on fixed console GPUs; see Official Docs pipeline compilation guidance in Reference.

### 3. Controller-Battery-Telemetry Hook
Use `Input.joy_connection_changed` + `Input.get_joy_info()` for hardware metadata; battery often needs a platform GDExtension under NDA.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Joypad indexing, deadzones, get_vector/get_connected_joypads, and why device 0 is never assumed Player 1 on consoles.
- [Controller number and vibration](https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html) — Finite start_joy_vibration durations, connection signals, and haptic accessibility toggles required by TRC/TCR.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event flow for InputEventJoypadButton/Motion, Input Map actions, and buffered flush before frame-critical checks.
- [Custom mouse cursor](https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html) — Input.set_mouse_mode / hidden cursor so a visible pointer does not fail console certification.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — Focus-out / suspend paths versus NOTIFICATION_WM_CLOSE_REQUEST, which consoles often never emit.
- [Keyboard, mouse, and controller UI navigation](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html) — Focus neighbors and D-Pad/gamepad UI traversal required when analog-only menus fail accessibility/TRC.
- [Resolution scaling](https://docs.godotengine.org/en/stable/tutorials/3d/resolution_scaling.html) — Viewport FSR2 / scaling_3d_scale profiles used to hold locked 30/60 FPS on weak SKUs.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — user:// persistence, save indicators, and why res:// writes are invalid on exported console builds.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Threaded ResourceLoader prefetch so slow console storage does not hitch level transitions.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool offload for atomic saves and prefetch without main-thread TCR frame spikes.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — OS.has_feature / export tags that gate console boot overrides (VSync, max FPS, low-end GI).
- [Reducing stutter from shader/pipeline compilations](https://docs.godotengine.org/en/stable/tutorials/performance/pipeline_compilations.html) — Shader/pipeline caching on fixed console GPUs to avoid first-use hitch rejections.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, Input Map, and export/user paths before certification hooks and console boot overrides.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Joypad actions, deadzones, and device remapping that controller-first UI and prompt mappers build on.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed notifications, signals, and thread-safe call patterns used by compliance and async save managers.

#### Complements
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Export presets, feature tags, and template discipline (console SDKs stay NDA-bound outside this skill).
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Atomic rename, cloud-ready slots, and save UX that TRC save indicators wrap.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Focusable Control trees and D-Pad neighbor graphs for gamepad-only menus.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Frame budgets, FSR scaling, and Server-side entity patterns that keep locked FPS under TCR.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Memory/profiler tabs and monitors used to enforce Switch-class RAM ceilings.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Aggressive queue_free / load queues so scene transitions stay inside console RAM budgets.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource caching and unload strategies paired with memory budget guards.

#### Downstream / consumers
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Dual-ship PC builds that must share Input Map/actions while keeping console mouse-hidden and FPS-locked paths.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Shared focus-loss / suspend pause patterns when the same title also targets handhelds.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Online matchmaking/friends hooks that sit beside achievement queues and platform overlays.
- [godot-genre-party](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md) — Multi-pad local play that consumes dynamic joypad slot discovery and prompt mapping.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
