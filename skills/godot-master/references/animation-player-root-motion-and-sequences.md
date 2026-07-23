# Root motion, sequences, RESET

## Root motion (physics sync)

**Problem:** Walk cycles move bones/skeleton but `CharacterBody3D` stays put — world collision does not follow.

**Scene:** `CharacterBody3D` → `MeshInstance3D` → `Skeleton3D` + `AnimationPlayer`

```gdscript
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    anim_player.root_motion_track = NodePath("MeshInstance3D/Skeleton3D:root")
    anim_player.play("walk")

func _physics_process(delta: float) -> void:
    var root_motion_pos := anim_player.get_root_motion_position()
    var root_motion_rot := anim_player.get_root_motion_rotation()

    var transform := Transform3D(
        basis.rotated(basis.y, root_motion_rot.y),
        root_motion_pos
    )
    global_transform *= transform
    velocity = root_motion_pos / delta
    move_and_slide()
```

Full recipe: [root_motion_physics_sync.gd](../scripts/animation_player_root_motion_physics_sync.gd).

> **WHY:** Root motion belongs on the physics tick. `speed_scale` drifts over long sessions — for rhythm/multiplayer sync use `seek()` against a shared clock.

## Sequences and blend times

```gdscript
# Await chain
anim.play("attack_1")
await anim.animation_finished
anim.play("attack_2")

# Or queue (no await)
anim.play("attack_1")
anim.queue("attack_2")
anim.queue("idle")

# Blend: play(name, custom_blend=-1, custom_speed=1.0, custom_fade=0.5)
anim.play("run", -1, 1.0, 0.5)
anim.set_default_blend_time(0.3)
```

Branching combos: [animation_sequencer.gd](../scripts/animation_player_animation_sequencer.gd).

## RESET track

Without RESET, animated properties stick when scenes reload or libraries swap.

```gdscript
var reset_anim := Animation.new()
reset_anim.length = 0.01

var track := reset_anim.add_track(Animation.TYPE_VALUE)
reset_anim.track_set_path(track, "Sprite2D:position")
reset_anim.track_insert_key(track, 0.0, Vector2.ZERO)

anim_player.add_animation("RESET", reset_anim)
# Enable "Reset on Save" on AnimationPlayer in editor
```

Orchestration across many tracks: [reset_track_orchestrator.gd](../scripts/animation_player_reset_track_orchestrator.gd).

## Procedural generation

Runtime bounce / juice without baking FBX: [programmatic_anim.gd](../scripts/animation_player_programmatic_anim.gd), [procedural_track_modifier.gd](../scripts/animation_player_procedural_track_modifier.gd).

## Shared libraries

Inject once, play `library_name/clip_name`:

```gdscript
anim_player.add_animation_library(&"shared_human", shared_library)
anim_player.play(&"shared_human/walk")
```

See [runtime_anim_lib_swapper.gd](../scripts/animation_player_runtime_anim_lib_swapper.gd). **Never** mutate a library while that library's clip is playing — stop first.

## Budget / culling

Off-screen visual-only players: set `active = false` or manual `advance()` — [active_animation_culler.gd](../scripts/animation_player_active_animation_culler.gd).
