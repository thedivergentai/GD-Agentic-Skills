---
name: godot-theme-easter
description: "Apply a Classic Easter seasonal overlay: pastel Theme/StyleBox injection, confetti/shimmer VFX, elastic juice, mesh surface_override painting, cursor/audio swaps, and a date-window activation gate with player opt-out. Use when shipping holiday skins, April events, or egg-hunt juice without mutating shared .mesh/.tres assets. Keywords: pastel, seasonal Theme, StyleBox, confetti, Easter egg, surface_override, TRANS_ELASTIC, Disable Seasonal Themes, activation gate."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Easter Theme (Aesthetics & Juice)

## Overview
Seasonal "Easter-fy" toolkit: bright pastels, bouncy juice, egg/bunny iconography — gated by calendar + settings.

**MANDATORY first read:** [easter_seasonal_activation_gate.gd](scripts/easter_seasonal_activation_gate.gd) — date window, `Disable Seasonal Themes` opt-out (`user://settings.cfg`), and Dev Override. Call `refresh_activation()` when settings change; never poll the calendar in `_process`.

**Prerequisite:** Do **NOT Load** [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) until a base `Theme` resource exists — seasonal overlays inject StyleBox overrides; they do not replace foundational Theme authoring.

## Seasonal Bootstrap (ordered)

1. **Gate** — Attach [easter_seasonal_activation_gate.gd](scripts/easter_seasonal_activation_gate.gd); call `refresh_activation()` on `_ready` and when settings change.
2. **Theme** — If gate active: **MANDATORY** [easter_runtime_ui_themer.gd](scripts/easter_runtime_ui_themer.gd) using tokens from [easter_pastel_color_palette.gd](scripts/easter_pastel_color_palette.gd).
3. **Audio** — **MANDATORY** [easter_seasonal_audio_swapper.gd](scripts/easter_seasonal_audio_swapper.gd) to map standard UI SFX → seasonal streams.
4. **Juice** — Layer confetti/shimmer/cursor/wobble scripts only after steps 1–3 pass (gate off = skip 2–4 entirely).

## Decision Tree — Alternate Painters (pick one)

| Context | Use | Do NOT also wire |
|---------|-----|------------------|
| 3D mesh seasonal tint via `surface_override` | [easter_mesh_painter_override.gd](scripts/easter_mesh_painter_override.gd) | [easter_palette_override.gd](scripts/easter_palette_override.gd) on same mesh |
| 2D/modulate or material slot swap already wired | [easter_palette_override.gd](scripts/easter_palette_override.gd) or [seasonal_material_swapper.gd](scripts/seasonal_material_swapper.gd) | mesh_painter on the same target |

## Core Components (Expert Easter Tools)

### [easter_seasonal_activation_gate.gd](scripts/easter_seasonal_activation_gate.gd)
**MANDATORY** — Date-aware manager with opt-out + Dev Override.

### [easter_pastel_color_palette.gd](scripts/easter_pastel_color_palette.gd)
**Single source of truth** for pastel Color tokens — do not hardcode hex lists in SKILL bodies or random scripts.

### [easter_runtime_ui_themer.gd](scripts/easter_runtime_ui_themer.gd)
Runtime theme injector for applying mass pastel styles across the UI tree.

### [easter_squash_stretch_juice.gd](scripts/easter_squash_stretch_juice.gd)
Expert 'Squash and Stretch' logic for organic egg-like interactions using Tweens.

### [easter_shimmer_vfx_emitter.gd](scripts/easter_shimmer_vfx_emitter.gd)
Professional 'Hidden Item' shimmer effect with additive blending and scale curves.

### [easter_egg_collection_tracker.gd](scripts/easter_egg_collection_tracker.gd)
Expert registry for tracking hidden items with signal-based progression signals.

### [easter_mesh_painter_override.gd](scripts/easter_mesh_painter_override.gd)
Seasonal 3D material swapper using surface overrides to preserve base assets.

### [easter_wobble_physics_body.gd](scripts/easter_wobble_physics_body.gd)
Instability-driven physics body for 'Egg-like' wobbly movement.

### [easter_camera_pop_juice.gd](scripts/easter_camera_pop_juice.gd)
Immersive FOV 'kick' logic to emphasize collection or pop events.

### [easter_confetti_canon_vfx.gd](scripts/easter_confetti_canon_vfx.gd)
Celebratory confetti explosion with multi-colored pastel flakes.

### [easter_custom_cursor_manager.gd](scripts/easter_custom_cursor_manager.gd)
Expert logic for swapping system mouse cursors with themed Easter icons.

### [easter_seasonal_audio_swapper.gd](scripts/easter_seasonal_audio_swapper.gd)
Dynamic audio resource loader that replaces standard UI sounds with seasonal variants.

### [easter_palette_override.gd](scripts/easter_palette_override.gd) / [seasonal_material_swapper.gd](scripts/seasonal_material_swapper.gd)
Alternate painters — see **Decision Tree — Alternate Painters** above; pick one path per target.

## Visual Guidelines
- **Colors:** Import tokens from [easter_pastel_color_palette.gd](scripts/easter_pastel_color_palette.gd) (`PINK`, `BLUE`, `YELLOW`, `MINT`, `PURPLE`) — never paste ad-hoc hex laundry lists into features.
- **Shapes:** Rounded corners (`corner_radius` > 8–12). Avoid sharp edges / high-contrast blacks.
- **VFX:** Confetti, sparkles, ribbons via confetti/shimmer scripts.

## NEVER Do (Expert Easter Rules)

### Aesthetics & Juice
- **NEVER use sharp edges or high-contrast blacks** — Easter aesthetics favor rounded corners (`corner_radius > 12`) and soft pastel tones.
- **NEVER use standard linear scaling for pops** — Linear scaling feels 'robotic.' Always use `TRANS_ELASTIC` or `TRANS_QUART` for organic eggs.
- **NEVER use billboarding for Easter particles** — In close-up UI or VR, billboard sparkles look flat. Use mesh-based particles or axial rotation.

### Logic & Performance
- **NEVER modify the original .mesh or .tres resource** — Swapping materials on a shared Resource changes it for EVERY instance in the game. Always use `surface_override` or `duplicate()`.
- **NEVER run date-checks in _process** — Checking the system calendar every frame is wasteful. Run `Time.get_date_dict_from_system()` once on `_ready` or event trigger via the activation gate.
- **NEVER ignore the 'No-Seasonal' toggle** — Some players hate seasonal overrides. Always provide a 'Disable Seasonal Themes' option in settings (wired through the gate's ConfigFile keys).

## Elite Theming Hooks

- **Dynamic Z-Ordering**: Use `RenderingServer.canvas_item_set_draw_index()` to dynamically move collected egg particles to the front of the UI stack without reparenting nodes.
- **Physics Interpolation**: When using `TRANS_ELASTIC` tweens on physics-driven eggs, invoke `RenderingServer.canvas_item_reset_physics_interpolation()` to prevent visual "jitter" on the first frame of the pop animation.
- **StyleBox Overrides**: Use `Control.add_theme_stylebox_override("panel", my_stylebox)` instead of modifying the global Theme to isolate seasonal changes to specific UI modules.

## Expert Easter Implementation

### 1. Custom-Mouse-Cursor (Juice)
**MANDATORY:** [easter_custom_cursor_manager.gd](scripts/easter_custom_cursor_manager.gd) — always set a `hotspot` (bunny-ear tip / base).

### 2. Themed-Sound-Loaders
**MANDATORY:** [easter_seasonal_audio_swapper.gd](scripts/easter_seasonal_audio_swapper.gd) — Resource map of original → seasonal `AudioStream` pairs.

### 3. World-Environment-Override (Spring Glow)
Tween `Environment` ambient/tonemap/fog during a transition — never hard-cut colors mid-frame.

```gdscript
func _apply_spring_env(env: Environment) -> void:
    var tween := create_tween()
    tween.tween_property(env, "ambient_light_color", EasterPastelColorPalette.YELLOW, 2.0)
    tween.tween_property(env, "tonemap_exposure", 1.2, 2.0)
    tween.tween_property(env, "fog_light_color", EasterPastelColorPalette.BLUE, 2.0)
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [GUI skinning](https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html) — Seasonal Theme swaps and StyleBox isolation.
- [Using the theme editor](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html) — Author Easter Theme variants without code-only skins.
- [Theme type variations](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html) — Egg/button variants without forking the whole theme.
- [Particle systems (2D)](https://docs.godotengine.org/en/stable/tutorials/2d/particle_systems_2d.html) — Confetti / shimmer VFX for collectible juice.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Elastic egg pops and camera punch.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — Spring WorldEnvironment glow/fog tweens.
- [Theme](https://docs.godotengine.org/en/stable/classes/class_theme.html) — Runtime seasonal Theme assignment.
- [Input](https://docs.godotengine.org/en/stable/classes/class_input.html) — Custom bunny cursor hotspots.
- [AudioStreamPlayer](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html) — Seasonal SFX bank playback.
- [RenderingServer](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html) — Draw-index and physics-interpolation fixes for juiced eggs.
- [GPUParticles2D](https://docs.godotengine.org/en/stable/classes/class_gpuparticles2d.html) — Confetti canons and shimmer emitters.
- [Environment](https://docs.godotengine.org/en/stable/classes/class_environment.html) — Ambient/tonemap/fog seasonal overrides.

### Related Skills

#### Prerequisites
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Base Theme architecture before seasonal overlays.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Asset folders and activation gates for seasonal packs.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Sound override maps and palette Resources.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Collection trackers and seasonal activation events.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Elastic TRANS pops and camera juice.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Confetti/shimmer emitters without reinventing GPUParticles.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Seasonal SFX banks and bus routing.
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — Squash/stretch juice on collectibles.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera pop punches on egg collect.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — Environment spring glow when the game is 3D.

#### Downstream / consumers
- [godot-genre-party](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md) — Seasonal party modes often reuse this juice stack.
- [godot-genre-puzzle](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md) — Collectible egg hunts as light puzzle content.
- [godot-game-loop-collection](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md) — Collection loops that consume seasonal trackers.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — If egg rewards gate progression, validate drop economies.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for seasonal themes.
