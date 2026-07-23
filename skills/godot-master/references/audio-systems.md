---
name: godot-audio-systems
description: "Expert patterns for Godot audio including AudioStreamPlayer variants (2D positional, 3D spatial), AudioBus mixing architecture, dynamic effects (reverb, EQ,compression), audio pooling for performance, music transitions (crossfade, bpm-sync), and procedural audio generation. Use for music systems, sound effects, spatial audio, or audio-reactive gameplay. Trigger keywords: AudioStreamPlayer, AudioStreamPlayer2D, AudioStreamPlayer3D, AudioBus, AudioServer, AudioEffect, music_crossfade, audio_pool, positional_audio, reverb, bus_volume."
---
# Audio Systems

Expert mixing, spatial, pooling, and interactive-music patterns for Godot's audio engine.

## NEVER Do (Expert Audio Rules)

### Mixing & Buses
- **NEVER set bus volume with linear values** — `set_bus_volume_db()` is logarithmic. Use `linear_to_db()` for sliders OR everything will sound too loud until the last 5%.
- **NEVER skip 'Bus Routing'** — Playing music on the 'SFX' bus makes volume menus useless. Strictly route every player to its dedicated sub-bus (Music, SFX, UI, Voice).
- **NEVER use 'Master' for gameplay sounds** — Dedicate Master to final limiting. Route all gameplay to sub-groups so you can mute/duck categories.

### Positional & Spatial
- **NEVER use 3D players without an Attenuation Model** — Default is NONE. If you don't set it to `Inverse Distance`, a whisper on the other side of the map will be global volume.
- **NEVER play 3D sounds exactly on top of the listener** — Causes "Panning Jitter" where the sound snaps between Left/Right speakers. Offset by `0.1` units.
- **NEVER forget Doppler for high-speed objects** — A car flying by without `DOPPLER_TRACKING_PHYSICS_STEP` feels flat and static.

### Performance & Polish
- **NEVER spam same-frame sounds** — Playing 50 explosions at once causes constructive interference (clipping/distortion). Use a `Limiter` (`audio_voice_limiter_manager.gd`).
- **NEVER instantiate nodes for one-shots** — Creating a node, playing a 0.5s clap, and `queue_free()`ing causes frame-time spikes. Use a Pool.
- **NEVER skip Crossfades/Transitions** — Abrupt music cuts break immersion. Always use a 0.5s-1.0s `Tween` to bridge tracks.

---

## Godot 4.7: Audio Breaking Changes

- `AudioEffectSpectrumAnalyzer.tap_back_pos` **removed** — migrate analyzers to alternative tap APIs.
- `AudioStreamPlayer` default `area_mask` is now **0** (disabled), not layer 1. If using `Area2D`/`Area3D` `audio_bus_override`, explicitly set `area_mask` to layer 1 or your bus layer.

## Decision Matrix: Which AudioStreamPlayer?

| Feature | AudioStreamPlayer | AudioStreamPlayer2D | AudioStreamPlayer3D |
|---------|------------------|---------------------|---------------------|
| **Spatial** | Global | 2D panning | 3D positioning |
| **Doppler** | No | No | Yes |
| **Attenuation** | No | Distance-based | 3D falloff |
| **Reverb send** | No | No | Yes |
| **Use for** | Music, UI, VO | 2D games | 3D games |
| **Performance** | Fastest | Medium | Slowest |

## Golden Path → Scripts

> **MANDATORY** — open only the script that matches the row. Do **not** reinvent pools, duckers, or interactive graphs from memory.
>
> **Do NOT Load** every script below for one mix task.

| Need | Script |
|------|--------|
| One-shot SFX spam / voice steal | **MANDATORY** [audio_voice_pool_manager.gd](../scripts/audio_systems_audio_voice_pool_manager.gd) |
| Cap identical SFX (ear-bleed) | **MANDATORY** [audio_voice_limiter_manager.gd](../scripts/audio_systems_audio_voice_limiter_manager.gd) |
| Dialogue over music | **MANDATORY** [audio_bus_ducker_logic.gd](../scripts/audio_systems_audio_bus_ducker_logic.gd) |
| Bus layout / runtime mute | [audio_bus_manager.gd](../scripts/audio_systems_audio_bus_manager.gd) |
| Linear UI slider → dB | [audio_linear_volume_interpolator.gd](../scripts/audio_systems_audio_linear_volume_interpolator.gd) |
| Wall muffling | **MANDATORY** [audio_occlusion_raycast.gd](../scripts/audio_systems_audio_occlusion_raycast.gd) |
| Room reverb zones | [audio_environmental_reverb_zone.gd](../scripts/audio_systems_audio_environmental_reverb_zone.gd) |
| Vertical intensity stems | **MANDATORY** [audio_interactive_music_manager.gd](../scripts/audio_systems_audio_interactive_music_manager.gd) |
| Horizontal clip graph | [interactive_music_graph.gd](../scripts/audio_systems_interactive_music_graph.gd) + [references/interactive-music-deep-dive.md](audio-systems-interactive-music-deep-dive.md) |
| Adaptive music player wrapper | [audio_adaptive_music_player.gd](../scripts/audio_systems_audio_adaptive_music_player.gd) |
| Autoload SFX entry | [audio_manager.gd](../scripts/audio_systems_audio_manager.gd) |
| Footstep surface banks | [audio_footstep_surface_selector.gd](../scripts/audio_systems_audio_footstep_surface_selector.gd) |
| Procedural hum / engine | [audio_procedural_generator_synth.gd](../scripts/audio_systems_audio_procedural_generator_synth.gd) |
| Spectrum → gameplay / VFX | [audio_reactive_visualizer_component.gd](../scripts/audio_systems_audio_reactive_visualizer_component.gd), [audio_visualizer.gd](../scripts/audio_systems_audio_visualizer.gd) |
| Dialogue subtitle sync | [subtitle_sync_system.gd](../scripts/audio_systems_subtitle_sync_system.gd) |

## Available Scripts (catalog)

### [audio_voice_pool_manager.gd](../scripts/audio_systems_audio_voice_pool_manager.gd)
Priority voice pool with steal of lowest-priority oldest voice (hero voices protected).

### [audio_voice_limiter_manager.gd](../scripts/audio_systems_audio_voice_limiter_manager.gd)
Concurrency cap for identical SFX instances.

### [audio_bus_ducker_logic.gd](../scripts/audio_systems_audio_bus_ducker_logic.gd)
Sidechain-style dialogue-over-music ducking.

### [audio_bus_manager.gd](../scripts/audio_systems_audio_bus_manager.gd)
Runtime bus volume/mute helpers for Music/SFX/UI/Voice groups.

### [audio_manager.gd](../scripts/audio_systems_audio_manager.gd)
Autoload entry for play-one-shot routing onto the pool.

### [audio_linear_volume_interpolator.gd](../scripts/audio_systems_audio_linear_volume_interpolator.gd)
Musically-correct linear↔dB UI slider mapping.

### [audio_occlusion_raycast.gd](../scripts/audio_systems_audio_occlusion_raycast.gd)
Raycast muffling via attenuation filter cutoff.

### [audio_environmental_reverb_zone.gd](../scripts/audio_systems_audio_environmental_reverb_zone.gd)
Area3D-driven reverb/bus override zones.

### [audio_interactive_music_manager.gd](../scripts/audio_systems_audio_interactive_music_manager.gd)
`AudioStreamSynchronized` vertical stem intensity.

### [interactive_music_graph.gd](../scripts/audio_systems_interactive_music_graph.gd)
`AudioStreamInteractive` horizontal clip graph.

### [audio_adaptive_music_player.gd](../scripts/audio_systems_audio_adaptive_music_player.gd)
Adaptive music player wrapper for intensity-driven stems.

### [audio_footstep_surface_selector.gd](../scripts/audio_systems_audio_footstep_surface_selector.gd)
Physics-driven surface → sound-bank selection.

### [audio_procedural_generator_synth.gd](../scripts/audio_systems_audio_procedural_generator_synth.gd)
Realtime procedural tones for hums/engines/signals.

### [audio_reactive_visualizer_component.gd](../scripts/audio_systems_audio_reactive_visualizer_component.gd)
FFT spectrum → gameplay/visual driver.

### [audio_visualizer.gd](../scripts/audio_systems_audio_visualizer.gd)
Spectrum analyzer visualization helper.

### [subtitle_sync_system.gd](../scripts/audio_systems_subtitle_sync_system.gd)
Playback-position-accurate subtitle sync (latency-compensated).

## Expert Audio Patterns (pointers only)

### Bus architecture
Master = final limiter only. Gameplay → Music / SFX / UI / Voice sub-buses. Set volumes with `linear_to_db()` / `db_to_linear()`.

### Occlusion muffling
Ray source→listener; blocked → Tween `attenuation_filter_cutoff_hz` down. Prefer [audio_occlusion_raycast.gd](../scripts/audio_systems_audio_occlusion_raycast.gd).

### Interactive music
Horizontal (`AudioStreamInteractive`) vs vertical (`AudioStreamSynchronized`) — deep-dive in [references/interactive-music-deep-dive.md](audio-systems-interactive-music-deep-dive.md). Load scripts above; do not paste stem managers into scenes from memory.

### Subtitle sync formula
`pos = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()` — implemented in [subtitle_sync_system.gd](../scripts/audio_systems_subtitle_sync_system.gd).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Audio (tutorial index)](https://docs.godotengine.org/en/stable/tutorials/audio/index.html) — Entry point for buses, streams, effects, sync, mic, and TTS before diving into class pages.
- [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html) — Decibel scale, Master/sub-bus routing, and why linear slider values break mixing.
- [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html) — AudioStreamPlayer / 2D / 3D roles, randomizers, and how streams reach buses.
- [Audio effects](https://docs.godotengine.org/en/stable/tutorials/audio/audio_effects.html) — Bus FX chain (EQ, filters, reverb, compressor, limiter) for ducking and environment zones.
- [Sync the gameplay with audio and music](https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html) — Playback-position helpers (`get_time_since_last_mix`, latency) for BPM and subtitle sync.
- [Importing audio samples](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html) — WAV/Ogg/MP3 tradeoffs that decide pool size and CPU cost for SFX spam.
- [AudioServer](https://docs.godotengine.org/en/stable/classes/class_audioserver.html) — Runtime bus volume, mute, effect add/remove, and spectrum analyzer instances.
- [AudioStreamPlayer](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html) — Non-positional music/UI/voice player API used by pools and crossfade managers.
- [AudioStreamPlayer3D](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html) — Attenuation models, Doppler, and filter cutoff for spatial SFX and occlusion.
- [AudioStreamInteractive](https://docs.godotengine.org/en/stable/classes/class_audiostreaminteractive.html) — Clip graph / switch modes for horizontal combat↔explore music transitions.
- [AudioStreamSynchronized](https://docs.godotengine.org/en/stable/classes/class_audiostreamsynchronized.html) — Stem layering API (`set_sync_stream_volume`) for vertical intensity mixes.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Bus names, import defaults, and project audio latency settings must exist before runtime mix code.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Music/SFX pools and bus managers are almost always Autoloads; use this for singleton ownership and boot order.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, signals, and await/Tween patterns underpin pooling, ducking, and interactive music graphs.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Crossfades, sidechain duck ramps, and occlusion cutoff sweeps should be Tween-driven, not per-frame lerps.
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — Audio Playback + Call Method tracks keep dialogue VO and subtitles frame-locked across locales.
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Routes spoken lines to a Voice/Dialog bus and should trigger Music ducking from this skill’s bus helpers.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Occlusion muffling needs correct `PhysicsRayQueryParameters3D` masks from source to listener.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Spectrum analyzer magnitudes commonly drive shader uniforms or light energy for audio-reactive VFX.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Volume menus need linear→dB mapping (`linear_to_db`) wired to bus indices, not raw slider values.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist per-bus volume/mute so mixer choices survive relaunch without rewriting bus layout.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate here when voice pools, polyphony, or mix-callback cost still show up in profilers after pooling.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Use when SFX concurrency caps, “loudness budget,” or spam-vs-clarity tradeoffs need simulated balance passes (pairs with voice limiters).
- [godot-genre-rhythm](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md) — Consumes sync-with-audio timing helpers for note windows and BPM-aligned transitions.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hit/explosion layers must share SFX bus routing plus voice stealing so combat never clips the mix.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting audio concern.
