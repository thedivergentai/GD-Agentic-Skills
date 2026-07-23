# Scene Management Patterns Deep Dive (load on demand)

> **MANDATORY** for fade Autoloads, loading screens, spawn tracking, persistence holders, and PCK patch flows. Use bundled scripts first — this file fills gaps the condensed SKILL.md omits.

## Instant vs packed change

```gdscript
get_tree().change_scene_to_file("res://levels/level_2.tscn")
# or
var next_scene := load("res://levels/level_2.tscn") as PackedScene
get_tree().change_scene_to_packed(next_scene)
```

Prefer [async_scene_manager.gd](../scripts/async_scene_manager.gd) for threaded loads.

## Fade transition Autoload

```gdscript
extends CanvasLayer
signal transition_finished

func change_scene(scene_path: String) -> void:
    $AnimationPlayer.play("fade_out")
    await $AnimationPlayer.animation_finished
    get_tree().change_scene_to_file(scene_path)
    $AnimationPlayer.play("fade_in")
    await $AnimationPlayer.animation_finished
    transition_finished.emit()
```

See [scene_transition_manager.gd](../scripts/scene_transition_manager.gd).

## Async load loop

```gdscript
func load_scene_async(path: String) -> void:
    ResourceLoader.load_threaded_request(path)
    var progress := []
    while true:
        var status := ResourceLoader.load_threaded_get_status(path, progress)
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(path))
            break
        if status == ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed: " + path)
            break
        await get_tree().process_frame
```

## Loading screen with progress bar

Full pattern in [async_scene_manager.gd](../scripts/async_scene_manager.gd) — always handle `THREAD_LOAD_FAILED`.

## Dynamic spawn + tracking

```gdscript
const ENEMY_SCENE := preload("res://enemies/goblin.tscn")
var active_enemies: Array[Node] = []

func spawn_enemy(pos: Vector2) -> void:
    var enemy := ENEMY_SCENE.instantiate()
    enemy.global_position = pos
    add_child(enemy)
    active_enemies.append(enemy)
    enemy.tree_exited.connect(func(): active_enemies.erase(enemy))
```

High-frequency spawns → [scene_pool.gd](../scripts/scene_pool.gd).

## Persistence holder (manual root)

```gdscript
var persistent_scene: Node

func make_persistent(scene: Node) -> void:
    persistent_scene = scene
    scene.get_parent().remove_child(scene)
    get_tree().root.add_child(scene)
```

Prefer [persistent_data_preservation.gd](../scripts/persistent_data_preservation.gd) + Autoload data for most games.

## Expert: pool pre-fill

```gdscript
func pre_fill_pool(count: int) -> void:
    for i in range(count):
        var instance := scene.instantiate()
        instance.process_mode = Node.PROCESS_MODE_DISABLED
        instance.hide()
        add_child(instance)
        pool.append(instance)
```

## Expert: background staging

Start `load_threaded_request` during gameplay; swap when `THREAD_LOAD_LOADED` — [background_resource_loader.gd](../scripts/background_resource_loader.gd).

## Expert: PCK patch

```gdscript
func patch_scene(pck_path: String) -> void:
    if ProjectSettings.load_resource_pack(pck_path):
        get_tree().change_scene_to_file("res://patched_level.tscn")
```

## Expert: orphan leak audit

```gdscript
func check_leaks() -> void:
    var orphans := Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
    if orphans > 0:
        push_warning("Leaked %d nodes" % orphans)
        Node.print_orphan_nodes()
```

> **WHY:** Orphans after `change_scene` mean listeners or static refs still hold freed nodes.

## Cleanup before transition

Stop timers in group `timers`; `queue_free()` on a root is recursive in Godot 4 — no manual child loops.

## Reload current scene

`get_tree().reload_current_scene()` — expensive full disk reload; use only when intentional.
