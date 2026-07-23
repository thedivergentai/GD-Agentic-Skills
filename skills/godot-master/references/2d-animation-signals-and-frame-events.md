# Signals And Frame Events

## AnimatedSprite2D Signals (Expert Usage)

### animation_looped vs animation_finished

```gdscript
extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    # ✅ Correct: Use animation_looped for repeating animations
    anim.animation_looped.connect(_on_loop)
    
    # ✅ Correct: Use animation_finished ONLY for one-shots
    anim.animation_finished.connect(_on_finished)
    
    anim.play("run")  # Looping animation

func _on_loop() -> void:
    # Fires every loop iteration
    emit_particle_effect("dust")

func _on_finished() -> void:
    # Only fires for non-looping animations
    anim.play("idle")
```

### frame_changed for Event Triggering

```gdscript
# Frame-perfect event system (attacks, footsteps, etc.)
extends AnimatedSprite2D

signal attack_hit
signal footstep

# Define event frames per animation
const EVENT_FRAMES := {
    "attack": {3: "attack_hit", 7: "attack_hit"},
    "run": {2: "footstep", 5: "footstep"}
}

func _ready() -> void:
    frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
    var events := EVENT_FRAMES.get(animation, {})
    if frame in events:
        emit_signal(events[frame])
```

---

## Advanced Pattern: Animation State Sync

### Problem: play() Timing Glitch

When updating both animation and sprite properties (e.g., `flip_h` + animation change), `play()` doesn't apply until next frame, causing a 1-frame visual glitch.

```gdscript
# ❌ BAD: Glitches for 1 frame
func change_direction(dir: int) -> void:
    anim.flip_h = (dir < 0)
    anim.play("run")  # Applied NEXT frame
    # Result: 1 frame of wrong animation with correct flip

# ✅ GOOD: Force immediate sync
func change_direction(dir: int) -> void:
    anim.flip_h = (dir < 0)
    anim.play("run")
    anim.advance(0)  # Force immediate update
```

---

## set_frame_and_progress() for Smooth Transitions

Use when changing animations mid-animation without visual stutter:

```gdscript
# Example: Skin swapping without animation reset
func swap_skin(new_skin: String) -> void:
    var current_frame := anim.frame
    var current_progress := anim.frame_progress
    
    # Load new SpriteFrames resource
    anim.sprite_frames = load("res://skins/%s.tres" % new_skin)
    
    # ✅ Preserve exact animation state
    anim.play(anim.animation)  # Re-apply animation
    anim.set_frame_and_progress(current_frame, current_progress)
    # Result: Seamless skin swap mid-animation
```

---
