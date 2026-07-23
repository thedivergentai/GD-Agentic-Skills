# AnimationPlayer edge cases

Recipes moved out of `SKILL.md` body. Read only when debugging.

## Animation not playing

```gdscript
if not player.has_animation(anim_name):
    push_error("Missing animation: %s" % anim_name)
    return
player.play(anim_name)
```

Prefer `const` / `StringName` animation ids to avoid silent typos.

## Method track not firing

- Confirm track path points at the node that owns the method.
- Set call mode to **DISCRETE** (not CONTINUOUS).
- Method must exist and match keyed name/args.

## Seek without visual/physics update

```gdscript
player.seek(t, true)  # update=true for same-frame property reads
```

## Looped clips and finished signals

`animation_finished` does not fire for looping animations — use `animation_looped` or inspect `current_animation`.

## Library swap while playing

Stop the player (or await finished) before mutating / replacing an `AnimationLibrary`.
