# Audio pooling and bus architecture

## Pooling anti-pattern (WHY)

```gdscript
# BAD: 60 new nodes/sec at 60 FPS → ~3600 allocations/minute + frame spikes
func play_footstep() -> void:
    var player := AudioStreamPlayer.new()
    add_child(player)
    player.stream = load("res://audio/footstep.ogg")
    player.finished.connect(player.queue_free)
    player.play()
```

**Fix:** Pre-allocate a round-robin pool — [audio_voice_pool_manager.gd](../scripts/audio_voice_pool_manager.gd). Cap identical SFX with [audio_voice_limiter_manager.gd](../scripts/audio_voice_limiter_manager.gd) to avoid constructive clipping when 50 explosions stack.

## Bus layout

```
Master (limiter only)
├── Music
├── SFX
├── UI
└── Voice
```

- Never route gameplay to Master — mute/duck categories independently.
- `set_bus_volume_db()` is logarithmic; UI sliders need `linear_to_db()` — [audio_linear_volume_interpolator.gd](../scripts/audio_linear_volume_interpolator.gd).

```gdscript
# BAD
AudioServer.set_bus_volume_db(music_idx, 0.5)

# GOOD
AudioServer.set_bus_volume_db(music_idx, linear_to_db(0.5))
```

## 3D spatial gotchas

| Issue | Fix |
|-------|-----|
| Whisper heard globally | Set `attenuation_model = ATTENUATION_INVERSE_DISTANCE` |
| Panning jitter on listener | Offset source by ~0.1 units from camera |
| Flat fly-by | `doppler_tracking = DOPPLER_TRACKING_PHYSICS_STEP` |

## Godot 4.7

`AudioStreamPlayer.area_mask` defaults to **0** — set layer 1 (or your bus layer) when using Area audio overrides.

## Far-audio cull

Stop `AudioStreamPlayer3D` when listener distance > `max_distance * 1.5` to skip inaudible mix work.

## Edge cases

1. Stream assigned?
2. Bus muted?
3. `volume_db < -60` effectively silent
