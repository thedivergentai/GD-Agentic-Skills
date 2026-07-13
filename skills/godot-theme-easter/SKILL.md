---
name: godot-theme-easter
description: Use when applying a specific Easter holiday theme (Eggs, Bunnies, Pastels) to a game.
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Easter Theme (Aesthetics & Juice)

## Overview
This skill provides the assets and logic to "Easter-fy" a game. It focuses on the **Classic Easter** aesthetic: bright pastels, bouncy animations, and egg/bunny iconography.

## Core Components (Expert Easter Tools)

### [easter_squash_stretch_juice.gd](scripts/easter_squash_stretch_juice.gd)
Expert 'Squash and Stretch' logic for organic egg-like interactions using Tweens.

### [easter_runtime_ui_themer.gd](scripts/easter_runtime_ui_themer.gd)
Runtime theme injector for applying mass pastel styles across the UI tree.

### [easter_shimmer_vfx_emitter.gd](scripts/easter_shimmer_vfx_emitter.gd)
Professional 'Hidden Item' shimmer effect with additive blending and scale curves.

### [easter_seasonal_activation_gate.gd](scripts/easter_seasonal_activation_gate.gd)
Date-aware manager for automatic activation of seasonal event content.

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

### [easter_pastel_color_palette.gd](scripts/easter_pastel_color_palette.gd)
Static utility containing curated, harmonious Easter color tokens.

### [easter_custom_cursor_manager.gd](scripts/easter_custom_cursor_manager.gd)
Expert logic for swapping system mouse cursors with themed Easter icons.

### [easter_seasonal_audio_swapper.gd](scripts/easter_seasonal_audio_swapper.gd)
Dynamic audio resource loader that replaces standard UI sounds with seasonal variants.

## Visual Guidelines
- **Colors**:
    -   Pink: `#FFC1CC`
    -   Cyan: `#E0FFFF`
    -   Yellow: `#FFFFE0`
    -   Mint: `#98FF98`
- **Shapes**: Rounded corners (`corner_radius` > 8px). Avoid sharp edges.
- **VFX**: Confetti, sparkles, and ribbons.

## NEVER Do (Expert Easter Rules)

### Aesthetics & Juice
- **NEVER use sharp edges or high-contrast blacks** — Easter aesthetics favor rounded corners (`corner_radius > 12`) and soft pastel tones.
- **NEVER use standard linear scaling for pops** — Linear scaling feels 'robotic.' Always use `TRANS_ELASTIC` or `TRANS_QUART` for organic eggs.
- **NEVER use billboarding for Easter particles** — In close-up UI or VR, billboard sparkles look flat. Use mesh-based particles or axial rotation.

### Logic & Performance
- **NEVER modify the original .mesh or .tres resource** — Swapping materials on a shared Resource changes it for EVERY instance in the game. Always use `surface_override` or `duplicate()`.
- **NEVER run date-checks in _process** — Checking the system calendar every frame is wasteful. Run `Time.get_date_dict_from_system()` once on `_ready` or event trigger.
- **NEVER ignore the 'No-Seasonal' toggle** — Some players hate seasonal overrides. Always provide a 'Disable Seasonal Themes' option in settings.

## Elite Theming Hooks

- **Dynamic Z-Ordering**: Use `RenderingServer.canvas_item_set_draw_index()` to dynamically move collected egg particles to the front of the UI stack without reparenting nodes.
- **Physics Interpolation**: When using `TRANS_ELASTIC` tweens on physics-driven eggs, invoke `RenderingServer.canvas_item_reset_physics_interpolation()` to prevent visual "jitter" on the first frame of the pop animation.
- **StyleBox Overrides**: Use `Control.add_theme_stylebox_override("panel", my_stylebox)` instead of modifying the global Theme to isolate seasonal changes to specific UI modules.

## Expert Easter Implementation

### 1. Custom-Mouse-Cursor (Juice)
Replacing the standard arrow with a themed Easter icon (e.g., a bunny ear).
- **Implementation**:
    ```gdscript
    func _apply_easter_cursor():
        var cursor_img = preload("res://ui/easter/cursor_bunny.png")
        Input.set_custom_mouse_cursor(cursor_img, Input.CURSOR_ARROW, Vector2(16, 16))
    ```
- **Expert Note**: Always define a `hotspot` (the pixel that actually clicks). For a bunny ear, this is usually the center or base of the ear.

### 2. Themed-Sound-Loaders
Dynamically swapping UI sounds (e.g., button clicks) for "bouncy" or "egg-pop" variants.
- **Pattern**: Use a `Resource` map to store original vs. seasonal sound pairs.
    ```gdscript
    @export var sound_overrides: Dictionary # String -> AudioStream
    
    func play_seasonal_sfx(original_name: String):
        var stream = sound_overrides.get(original_name, default_sounds[original_name])
        sfx_player.stream = stream
        sfx_player.play()
    ```

### 3. World-Environment-Override (Spring Glow)
Using code to transition the game's atmosphere without creating a new scene.
- **Implementation**:
    ```gdscript
    func _apply_spring_env(env: Environment):
        var tween = create_tween()
        tween.tween_property(env, "ambient_light_color", Color("#FFF4E0"), 2.0)
        tween.tween_property(env, "tonemap_exposure", 1.2, 2.0)
        tween.tween_property(env, "fog_light_color", Color("#E0FFFF"), 2.0)
    ```
- **Expert Note**: Smoothly tweening these properties during a loading screen or transition prevents the "Sudden Change" glitch.
