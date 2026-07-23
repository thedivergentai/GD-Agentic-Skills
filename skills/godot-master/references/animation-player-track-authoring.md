# Track authoring (load on demand)

Moved from baseline expert body. Prefer bundled scripts for production code; use this when authoring tracks in editor or building `Animation` resources in code.

## Value tracks (property animation)

Animate any property path: position, modulate, shader uniforms, custom exports.

```gdscript
var anim := Animation.new()
anim.length = 2.0

var pos_track := anim.add_track(Animation.TYPE_VALUE)
anim.track_set_path(pos_track, ".:position")
anim.track_insert_key(pos_track, 0.0, Vector2(0, 0))
anim.track_insert_key(pos_track, 1.0, Vector2(100, 0))
anim.track_set_interpolation_type(pos_track, Animation.INTERPOLATION_CUBIC)

var color_track := anim.add_track(Animation.TYPE_VALUE)
anim.track_set_path(color_track, "Sprite2D:modulate")
anim.track_insert_key(color_track, 0.0, Color.WHITE)
anim.track_insert_key(color_track, 2.0, Color.TRANSPARENT)

$AnimationPlayer.add_animation("fade_move", anim)
$AnimationPlayer.play("fade_move")
```

> **CAUTION:** Animating `material.albedo_color` on an embedded sub-resource duplicates that resource into the scene file. Prefer `shader_parameter/*` on an instanced material or a dedicated uniform track path.

## Method tracks (function calls)

```gdscript
var method_track := anim.add_track(Animation.TYPE_METHOD)
anim.track_set_path(method_track, ".")

anim.track_insert_key(method_track, 0.5, {
    "method": "spawn_particle",
    "args": [Vector2(50, 50)]
})

# CRITICAL: DISCRETE fires once; CONTINUOUS fires every frame in the key span
anim.track_set_call_mode(method_track, Animation.CALL_MODE_DISCRETE)
```

Decouple gameplay from hardcoded methods via [method_track_logic.gd](../scripts/animation_player_method_track_logic.gd) (signaler pattern).

## Audio tracks

```gdscript
var audio_track := anim.add_track(Animation.TYPE_AUDIO)
anim.track_set_path(audio_track, "AudioStreamPlayer")

var footstep := load("res://sounds/footstep.ogg")
anim.audio_track_insert_key(audio_track, 0.3, footstep)
anim.audio_track_insert_key(audio_track, 0.6, footstep)
anim.audio_track_set_key_volume(audio_track, 0, 1.0)
anim.audio_track_set_key_volume(audio_track, 1, 0.7)
```

TYPE_AUDIO locks SFX to timeline frames better than calling `AudioStreamPlayer.play()` from method tracks.

## Bezier tracks

```gdscript
var bezier_track := anim.add_track(Animation.TYPE_BEZIER)
anim.track_set_path(bezier_track, ".:custom_value")
anim.bezier_track_insert_key(bezier_track, 0.0, 0.0)
anim.bezier_track_insert_key(bezier_track, 1.0, 100.0, Vector2(0.5, 0), Vector2(-0.5, 0))

# Sample at runtime — or use bezier_curve_extraction.gd for procedural drive
var value := $AnimationPlayer.get_bezier_value("custom_value")
```

## Play backwards / scrub

```gdscript
anim.play("door_open", -1, -1.0)  # speed -1 = reverse

# Cutscene scrub — seek with update=true when same-frame reads matter
anim.seek(anim.current_animation_length * 0.5, true)
```
