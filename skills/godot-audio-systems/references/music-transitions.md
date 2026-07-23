# Music transitions and ducking

## Crossfade (never hard-cut)

```gdscript
func crossfade_to(next_track: AudioStreamPlayer, fade := 2.0) -> void:
    next_track.stream = new_stream
    next_track.volume_db = -80.0
    next_track.play()
    var tween := create_tween().set_parallel(true)
    tween.tween_property(current_track, "volume_db", -80.0, fade)
    tween.tween_property(next_track, "volume_db", 0.0, fade)
    await tween.finished
    current_track.stop()
    current_track = next_track
```

Prefer Tween crossfades (0.5–2.0s). Abrupt `stop()`/`play()` breaks immersion.

## BPM-aligned handoff

```gdscript
var beat_duration := 60.0 / bpm
var pos := current_track.get_playback_position()
var wait := beat_duration - fmod(pos, beat_duration)
await get_tree().create_timer(wait).timeout
crossfade_to(next_stream)
```

## Dialogue ducking

Sidechain Music bus down while Voice plays — [audio_bus_ducker_logic.gd](../scripts/audio_bus_ducker_logic.gd). Route VO to Voice bus, not SFX.

## Vertical stems (`AudioStreamSynchronized`)

Fade with `set_sync_stream_volume(index, db)` over 1–2s Tweens driven by a 0–1 intensity signal — [audio_interactive_music_manager.gd](../scripts/audio_interactive_music_manager.gd). Deep rules: [interactive-music-deep-dive.md](interactive-music-deep-dive.md).

## Horizontal clips (`AudioStreamInteractive`)

Combat ↔ explore transitions on bar boundaries — [interactive_music_graph.gd](../scripts/interactive_music_graph.gd).

## Subtitle sync (no timer drift)

```
pos = get_playback_position()
    + AudioServer.get_time_since_last_mix()
    - AudioServer.get_output_latency()
```

Implemented in [subtitle_sync_system.gd](../scripts/subtitle_sync_system.gd). Method/Audio tracks in [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) for frame-locked VO.

## Variation

`pitch_scale = randf_range(0.9, 1.1)` on repeated footsteps/gunshots so identical samples do not phase-stack.

## Runtime bus FX

Reverb/low-pass on SFX bus for underwater or room zones — [audio_environmental_reverb_zone.gd](../scripts/audio_environmental_reverb_zone.gd). Occlusion via ray + `attenuation_filter_cutoff_hz` — [audio_occlusion_raycast.gd](../scripts/audio_occlusion_raycast.gd).
