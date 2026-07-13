---
name: godot-scene-management
description: "Expert blueprint for scene loading, transitions, async (background) loading, instance management, and caching. Covers fade transitions, loading screens, dynamic spawning, and scene persistence. Use when implementing level changes OR dynamic content loading. Keywords scene, loading, transition, async, ResourceLoader, change_scene, preload, PackedScene, fade."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Scene Management

Async loading, transitions, instance pooling, and caching define smooth scene workflows.

## Available Scripts

### [background_resource_loader.gd](scripts/background_resource_loader.gd)
Expert asynchronous scene loading with progress tracking and thread-safe transition.

### [scene_transition_manager.gd](scripts/scene_transition_manager.gd)
Clean implementation of scene fades and transitions using Tweens and Shaders.

### [additive_ui_layering.gd](scripts/additive_ui_layering.gd)
Managing UI overlays and menus without destroying the current world scene.

### [node_unparent_reparent.gd](scripts/node_unparent_reparent.gd)
Safe, transform-preserving reparenting of nodes between different scene trees.

### [persistent_data_preservation.gd](scripts/persistent_data_preservation.gd)
Pattern for using Autoloads to maintain player state and game data across scene changes.

### [scene_instancing_pooling.gd](scripts/scene_instancing_pooling.gd)
High-performance object pooling to eliminate the cost of frequent instantiation and freeing.

### [subviewport_scene_layering.gd](scripts/subviewport_scene_layering.gd)
Running parallel worlds or specialized rendering layers using `SubViewport` nodes.

### [node_path_safe_retrieval.gd](scripts/node_path_safe_retrieval.gd)
Robust node reference architecture using Unique Names and error-guarded @onready.

### [dynamic_script_attachment.gd](scripts/dynamic_script_attachment.gd)
Runtime script manipulation for modding systems or highly dynamic entity behavior.

### [async_scene_manager.gd](scripts/async_scene_manager.gd)
Expert async scene loader with progress tracking, error handling, and transition callbacks.
Expert async scene loader with progress tracking, error handling, and transition callbacks.

### [scene_pool.gd](scripts/scene_pool.gd)
Object pooling for frequently spawned scenes (bullets, godot-particles, enemies).

### [scene_state_manager.gd](scripts/scene_state_manager.gd)
Preserves and restores scene state across transitions using "persist" group pattern.

> **MANDATORY - For Smooth Transitions**: Read async_scene_manager.gd before implementing loading screens.


## NEVER Do in Scene Management

- **NEVER load large scenes synchronously** — `load("res://large_scene.tscn")` on the Main Thread causes "hiccups" or full freezes during level transitions. Use `ResourceLoader.load_threaded_request()` for async loading with a progress bar.
- **NEVER use `get_tree().change_scene_to_file()` for transient state** — This method purges the current scene and all its local variables. Use an **Autoload (Singleton)** or a persistent 'Game' node to store state across levels.
- **NEVER instance 100+ identical nodes per frame** — Use **Object Pooling** to reuse bullets, debris, or enemies. Constant `instantiate()` and `queue_free()` calls spike CPU and trigger the Garbage Collector too often.
- **NEVER hardcode `get_node("../../Path/To/Node")`** — These paths break as soon as you move a node in the editor. Use **Scene Unique Names** (`%NodeName`) or `@export var target_node: Node` for robust references.
- **NEVER reparent nodes mid-physics-step without care** — Reparenting can cause one-frame transform "teleports". Always store the `global_transform` and re-apply it after the `add_child()` call.
- **NEVER rely on the SceneTree for 10,000+ objects** — If you don't need SceneTree features (signals, per-node scripts), use `PhysicsServer` and `RenderingServer` directly for raw performance.
- **NEVER forget to handle `NOTIFICATION_WM_CLOSE_REQUEST`** — On desktop, if you don't handle the close request in a persistent node, the game may close during a critical save operation.
- **NEVER use deep recursion for node cleanup** — `queue_free()` is natively recursive in Godot 4. Freeing the root node automatically cleans up all children [6, 7]. Manual loops are redundant and inefficient.
- **NEVER mix `SubViewport` and main world inputs without a plan** — By default, input events bubble up. Use `set_input_as_handled()` to prevent UI clicks in a subviewport from triggering gameplay in the main world.
- **NEVER use `change_scene` to "Reset" a level** — It reloads everything from disk. For a quick respawn, just reset the variables and move the player to the start position.

---

```gdscript
# Instant scene change
get_tree().change_scene_to_file("res://levels/level_2.tscn")

# Or with packed scene
var next_scene := load("res://levels/level_2.tscn")
get_tree().change_scene_to_packed(next_scene)
```

## Scene Transition with Fade

```gdscript
# scene_transitioner.gd (AutoLoad)
extends CanvasLayer

signal transition_finished

func change_scene(scene_path: String) -> void:
    # Fade out
    $AnimationPlayer.play("fade_out")
    await $AnimationPlayer.animation_finished
    
    # Change scene
    get_tree().change_scene_to_file(scene_path)
    
    # Fade in
    $AnimationPlayer.play("fade_in")
    await $AnimationPlayer.animation_finished
    
    transition_finished.emit()

# Usage:
SceneTransitioner.change_scene("res://levels/level_2.tscn")
await SceneTransitioner.transition_finished
```

## Async (Background) Loading

```gdscript
extends Node

var loading_status: int = 0
var progress := []

func load_scene_async(path: String) -> void:
    ResourceLoader.load_threaded_request(path)
    
    while true:
        loading_status = ResourceLoader.load_threaded_get_status(
            path,
            progress
        )
        
        if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(path)
            get_tree().change_scene_to_packed(scene)
            break
        
        # Update loading bar
        print("Loading: ", progress[0] * 100, "%")
        await get_tree().process_frame
```

## Loading Screen Pattern

```gdscript
# loading_screen.gd
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func load_scene(path: String) -> void:
    show()
    ResourceLoader.load_threaded_request(path)
    
    var progress := []
    var status: int
    
    while true:
        status = ResourceLoader.load_threaded_get_status(path, progress)
        
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(path)
            get_tree().change_scene_to_packed(scene)
            break
        elif status == ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed to load scene: " + path)
            break
        
        progress_bar.value = progress[0] * 100
        await get_tree().process_frame
    
    hide()
```

## Dynamic Scene Instances

### Add Scene as Child

```gdscript
# Spawn enemy at runtime
const ENEMY_SCENE := preload("res://enemies/goblin.tscn")

func spawn_enemy(position: Vector2) -> void:
    var enemy := ENEMY_SCENE.instantiate()
    enemy.global_position = position
    add_child(enemy)
```

### Instance Management

```gdscript
# Keep track of spawned enemies
var active_enemies: Array[Node] = []

func spawn_enemy(pos: Vector2) -> void:
    var enemy := ENEMY_SCENE.instantiate()
    enemy.global_position = pos
    add_child(enemy)
    active_enemies.append(enemy)
    
    # Clean up when enemy dies
    enemy.tree_exited.connect(
        func(): active_enemies.erase(enemy)
    )

func clear_all_enemies() -> void:
    for enemy in active_enemies:
        enemy.queue_free()
    active_enemies.clear()
```

## Sub-Scenes

```gdscript
# Load UI as sub-scene
@onready var ui := preload("res://ui/game_ui.tscn").instantiate()

func _ready() -> void:
    add_child(ui)
```

## Scene Persistence

```gdscript
# Keep scene loaded when changing scenes
var persistent_scene: Node

func make_persistent(scene: Node) -> void:
    persistent_scene = scene
    scene.get_parent().remove_child(scene)
    get_tree().root.add_child(scene)

func restore_persistent() -> void:
    if persistent_scene:
        get_tree().root.remove_child(persistent_scene)
        add_child(persistent_scene)
```

## Reload Current Scene

```gdscript
# Restart level
get_tree().reload_current_scene()
```

## Expert Scene Patterns

### 1. Node-Pooling-Pre-instantiation
To avoid frame drops during combat, pre-fill your pools during a loading screen. This absorbs the instantiation cost upfront [1].

```gdscript
# Inside Pool Manager
func pre_fill_pool(count: int):
    for i in range(count):
        var instance = scene.instantiate()
        instance.process_mode = Node.PROCESS_MODE_DISABLED
        instance.hide()
        add_child(instance)
        pool.append(instance)
```

### 2. Scene-Transition-Staging
Load sub-scenes or upcoming levels in the background during active gameplay using `ResourceLoader.load_threaded_request()` to prevent transition hitches [3, 4].

```gdscript
func start_background_load(path: String):
    ResourceLoader.load_threaded_request(path)

func _process(_d):
    var status = ResourceLoader.load_threaded_get_status(path, progress)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var scene = ResourceLoader.load_threaded_get(path)
        # Transition when ready...
```

### 3. Scene Patcher (Runtime PCK Overrides)
Hot-swap scenes or load modular DLC using `ProjectSettings.load_resource_pack()`. This mounts a `.pck` file into the virtual filesystem, overriding existing `res://` paths [4, 6].

```gdscript
func patch_scene(pck_path: String):
    if ProjectSettings.load_resource_pack(pck_path):
        # The next load() call will fetch the patched version from the PCK
        get_tree().change_scene_to_file("res://patched_level.tscn")
```

### 4. Memory Leak Detector
Track orphan nodes during scene transitions using the `Performance` singleton. If `OBJECT_ORPHAN_NODE_COUNT` is > 0, nodes were leaked [2, 10].

```gdscript
func check_leaks():
    var orphans = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
    if orphans > 0:
        print_warning("Leaked %d nodes!" % orphans)
        Node.print_orphan_nodes()
```

### 5. Natively Recursive Cleanup
In Godot 4, `queue_free()` handles the entire node tree. You never need a manual `for child in get_children(): child.queue_free()` loop. This is handled at the engine level for maximum efficiency [7].

## Best Practices

### 1. Use SceneTransitioner AutoLoad

```gdscript
# Centralized scene management
# All transitions go through one system
# Consistent fade effects
```

### 2. Preload Common Scenes

```gdscript
# ✅ Good - preload at compile time
const BULLET := preload("res://projectiles/bullet.tscn")

# ❌ Bad - load at runtime
var bullet := load("res://projectiles/bullet.tscn")
```

### 3. Clean Up Before Transition

```gdscript
func change_level() -> void:
    # Clear timers, tweens, etc.
    for timer in get_tree().get_nodes_in_group("timers"):
        timer.stop()
    
    SceneTransitioner.change_scene("res://levels/next.tscn")
```

### 4. Error Handling

```gdscript
func load_scene_safe(path: String) -> bool:
    if not ResourceLoader.exists(path):
        push_error("Scene not found: " + path)
        return false
    
    get_tree().change_scene_to_file(path)
    return true
```

## Reference
- [Godot Docs: SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html)
- [Godot Docs: Background Loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html)


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
