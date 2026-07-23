---
name: godot-genre-rhythm
description: "Expert blueprint for rhythm games including audio synchronization (BPM conductor, latency compensation with AudioServer.get_time_since_last_mix), note highways (scroll speed, timing windows), judgment systems (Perfect/Great/Good/Bad/Miss), scoring with combo multipliers, input processing (lane-based, hold note detection), and chart/beatmap loading. Based on DDR/osu!/Beat Saber research. Trigger keywords: rhythm_game, audio_sync, timing_judgment, note_highway, combo_system, BPM_conductor, latency_compensation."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Rhythm

Expert blueprint for rhythm games emphasizing audio-visual synchronization and flow state.

## NEVER Do (Expert Anti-Patterns)

### Audio Sync & Logic
- NEVER use `Time.get_ticks_msec()` / `Time.get_ticks_usec()` as the song clock; strictly use **`AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()`** (see [rhythm_conductor.gd](scripts/rhythm_conductor.gd)).
- NEVER process song logic in `_process()`; strictly use **`_physics_process()`** or a conductor loop to ensure deterministic timing regardless of render frames.
- NEVER use `_process()` to capture hit inputs; strictly use **`_input(event)`** to record the exact timestamp of the button press event.
- NEVER scale engine time_scale for song speed; strictly use **`AudioStreamPlayer.pitch_scale`** to adjust speed and avoid globally breaking physics logic.
- NEVER neglect **Audio Latency** calibration; strictly provide a tool for players to adjust for hardware/Bluetooth delays (~30-100ms) to prevent "unplayable" sync issues.
- NEVER use `_process` delta as the song clock; strictly read the conductor's `get_song_time()` (playback + mix − output latency).
- NEVER move thousands of note sprites on the CPU; strictly use a **Shader-Based Highway** (UV scrolling) to offload track movement to the GPU.
- NEVER use `yield` or `await` for beat timing; strictly use a sample-accurate **Delta Accumulator** tied to the audio clock.
- NEVER assume a constant BPM; strictly build your conductor to handle a **Tempo Map** for complex track changes.

### Feedback & Performance
- NEVER judge inputs based on world position (pixels); strictly judge against the **Song's Elapsed Time (ms)** to ensure consistency across resolutions.
- NEVER play hit sounds with static pitch; strictly add **±5% Random Pitch Variation** to hit sounds to avoid the "machine gun" effect.
- NEVER use tight timing windows (e.g., <25ms) for all players; strictly use **Wider Windows for Beginners** to prevent immediate frustration.
- NEVER instantiate note nodes every beat; strictly use **Object Pooling** to recycle note instances and prevent GC spikes during dense tracks.
- NEVER use standard Area2D signals for rhythmic hits; strictly **Poll Inputs** in the conductor loop to compare against target timestamps.
- NEVER calculate FFT for visualization on the main thread; strictly use **AudioEffectSpectrumAnalyzerInstance** for optimized engine-side analysis.
- NEVER allow note spamming/mashing; strictly penalize misses or break combos to maintain the game's integrity.
- NEVER use `load()` dynamically during gameplay; strictly use **ResourceLoader.load_threaded_request()** to avoid thread stalling.
- NEVER forget to pause the conductor/ highway; strictly sync with the audio player's pause state to prevent notes from scrolling while the music is stopped.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [rhythm_conductor.gd](scripts/rhythm_conductor.gd) — canonical audio clock
> 2. [input_judge_logic.gd](scripts/input_judge_logic.gd) — time-window judging
> 3. [note_object_pool.gd](scripts/note_object_pool.gd) — pooled notes (no per-beat instantiate)
> 4. [latency_calibrator.gd](scripts/latency_calibrator.gd) — player hardware offset

### Original Expert Patterns
- [rhythm_conductor.gd](scripts/rhythm_conductor.gd) - Song time = playback_position + mix − output latency.
- [input_judge_logic.gd](scripts/input_judge_logic.gd) - ms windows vs song time (not pixel position).
- [note_object_pool.gd](scripts/note_object_pool.gd) - Recycle note instances under dense charts.
- [latency_calibrator.gd](scripts/latency_calibrator.gd) - Calibration UI offset applied on the conductor.

### Modular Components
- [note_orchestrator.gd](scripts/note_orchestrator.gd) - Spawn/schedule notes from chart data.
- [rhythm_scoring_system.gd](scripts/rhythm_scoring_system.gd) - Score aggregation from judgments.
- [score_combo_manager.gd](scripts/score_combo_manager.gd) - Combo / break rules.
- [rhythm_ui_feedback.gd](scripts/rhythm_ui_feedback.gd) - Hit sparks / judgment labels.
- [beat_synced_animator.gd](scripts/beat_synced_animator.gd) - Visuals locked to conductor beats.
- [note_lane_manager.gd](scripts/note_lane_manager.gd) - Multi-lane layout helpers.
- [dynamic_bpm_handler.gd](scripts/dynamic_bpm_handler.gd) - Tempo map / BPM changes.
- [audio_spectrum_analyzer.gd](scripts/audio_spectrum_analyzer.gd) - Spectrum visuals (not the clock).

> **Do NOT load** unused lanes: skip [audio_spectrum_analyzer.gd](scripts/audio_spectrum_analyzer.gd) unless building reactive viz; skip [dynamic_bpm_handler.gd](scripts/dynamic_bpm_handler.gd) for constant-BPM tracks.

---

## Core Loop
1. **Calibrate latency** → 2. **Conductor clock** → 3. **Spawn pooled notes** → 4. **`_input` judge** → 5. **Score/combo UI**

## Decision Trees

### Clock (one recipe)
| Need | Action |
|------|--------|
| Song position | **MANDATORY** [rhythm_conductor.gd](scripts/rhythm_conductor.gd) `get_song_time()` |
| Visual highway | Position from song time / beats — never `_process` delta integration as truth |
| Hit timestamp | Capture in `_input` / `_unhandled_input`, compare to note target time |

### Systems
| Need | Action |
|------|--------|
| Judgment windows | [input_judge_logic.gd](scripts/input_judge_logic.gd) |
| Scoring / combo | [rhythm_scoring_system.gd](scripts/rhythm_scoring_system.gd) + [score_combo_manager.gd](scripts/score_combo_manager.gd) |
| Chart spawn | [note_orchestrator.gd](scripts/note_orchestrator.gd) + pool |
| Juice | [rhythm_ui_feedback.gd](scripts/rhythm_ui_feedback.gd) / [beat_synced_animator.gd](scripts/beat_synced_animator.gd) |

Do **not** re-inline MusicConductor / NoteHighway / JudgmentSystem / RhythmScoring classes in this skill — load the scripts.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Audio | `godot-audio-systems` | Stream clock + latency |
| 2. Input | `godot-input-handling` | Timestamped hits |
| 3. UI | `godot-ui-containers` | Highway / HUD |
| 4. Perf | pooling / shaders | Dense charts |
| 5. Balance | `godot-monte-carlo-balancer` | Window difficulty bands |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| `Time.get_ticks_*` conductor | Use playback + mix − latency |
| Judge in `_process` | `_input` + song time |
| Instantiate per note | [note_object_pool.gd](scripts/note_object_pool.gd) |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Sync the gameplay with audio and music](https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html) — Playback-position helpers (`get_time_since_last_mix`, output latency) that every BPM conductor and judgment window must use.
- [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html) — AudioStreamPlayer roles, pitch_scale for song speed, and how music reaches buses without breaking sync.
- [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html) — Route Music / HitSFX / UI so judgment SFX never fight the track bus.
- [Importing audio samples](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html) — WAV vs Ogg/MP3 tradeoffs for charts, hit clicks, and calibration tones.
- [AudioServer](https://docs.godotengine.org/en/stable/classes/class_audioserver.html) — Mix/output latency APIs and bus-effect instances used by conductors and spectrum visuals.
- [AudioStreamPlayer](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html) — Non-positional music/hit player API (`get_playback_position`, `pitch_scale`, pause) for the highway clock.
- [AudioEffectSpectrumAnalyzer](https://docs.godotengine.org/en/stable/classes/class_audioeffectspectrumanalyzer.html) — Engine-side FFT effect for reactive highways without main-thread FFT work.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — `_input` / action press timing for lane hits instead of polling in `_process`.
- [CanvasItem shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html) — UV scroll patterns for GPU note highways that avoid moving thousands of sprites on CPU.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Judgment splash, receptor pulse, and beat-synced scale pops without frame-tied lerps.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Threaded chart/audio preload so dense tracks never stall the first note.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Audio latency project settings, bus layout names, and input map lane actions must exist before the conductor runs.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Buses, stream players, spectrum instances, and sync-with-audio helpers this genre skill consumes for BPM clocks.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Action maps, `_input` vs `_unhandled_input`, and event timestamps for lane press/release and anti-spam.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources for NoteData/charts, signals for beat/judgment events, and deterministic timing loops.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Judgment labels, receptor flashes, and beat pulses should be Tween-driven, not per-frame scale hacks.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Shader highways and spectrum-driven uniforms keep dense charts off the CPU.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Hit sparks and combo flourishes via GPUParticles2D without instantiating VFX every Perfect.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Score/combo HUD, calibration sliders, and lane receptor layout as Control trees.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist A/V offset, scroll speed, and difficulty windows across sessions.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Conductor / scoring / pool owners are typically Autoloads with a clear boot order.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Beat, judgment, combo-break, and chart-finished signals need owner boundaries so UI never owns the clock.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when note pools, highway draw calls, or mix callbacks still hitch after pooling and shader scroll.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate timing-window width, scroll speed, and miss penalties against clear rates before shipping difficulty tiers.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting rhythm concern.
