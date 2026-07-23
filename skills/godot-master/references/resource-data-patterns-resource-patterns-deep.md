# Resource & Data Patterns Deep Dive (load on demand)

> **MANDATORY** when authoring ItemData/CharacterStats databases, nested weapon trees, flyweight caches, or runtime loot generation. Implement from bundled scripts — do not reconstruct Pattern 1–7 from memory.

## Resource vs RefCounted vs Node

| Type | Use when | Disk / Inspector |
|------|----------|------------------|
| `Resource` | Shared defs, saveable data | `.tres`/`.res` ✅ |
| `RefCounted` | Ephemeral calc helpers | No disk |
| `Node` | Scene entities | `.tscn` |

## Pattern 1: Custom Resource (`ItemData`)

```gdscript
extends Resource
class_name ItemData

@export var item_name: String = ""
@export_enum("Weapon", "Consumable", "Armor") var item_type: int = 0
@export var icon: Texture2D
@export var stackable: bool = false
```

Create in Inspector → Save as `res://items/health_potion.tres`.

## Pattern 2: Character stats + duplicate trap

> **CAUTION:** Runtime HP/mana on a shared `.tres` mutates the asset on disk for every instance. Use `duplicate()` or `resource_local_to_scene` — see [resource_local_to_scene.gd](../scripts/resource_data_patterns_resource_local_to_scene.gd).

```gdscript
@export var stats: CharacterStats

func _ready() -> void:
    if stats:
        stats = stats.duplicate_stats()  # or stats.duplicate(true)
```

## Pattern 3: Database (`Array[ItemData]`)

```gdscript
extends Resource
class_name ItemDatabase

@export var items: Array[ItemData] = []

func get_item_by_name(item_name: String) -> ItemData:
    for item in items:
        if item.item_name == item_name:
            return item
    return null
```

Autoload: `const ITEM_DB := preload("res://data/item_database.tres")`.

## Pattern 4: RefCounted scratchpad (`DamageCalculation`)

Use when data must **not** persist — see [data_factory_resource.gd](../scripts/resource_data_patterns_data_factory_resource.gd) for hybrid factories.

## Pattern 5: Nested resources + `.res` vs `.tres`

- `ResourceSaver` serializes nested sub-resources recursively with the parent.
- Production: prefer binary `.res` for speed/size; design-time: `.tres` for diffs.
- `ResourceLoader.CACHE_MODE_REPLACE` when hot-reloading edited assets.

## Pattern 6: Inventory Resource with signals

```gdscript
signal item_added(item: ItemData)
signal item_removed(item: ItemData)

func add_item(item: ItemData) -> void:
    items.append(item)
    item_added.emit(item)
```

## Pattern 7: Runtime directory scan

```gdscript
func load_all_items() -> Array[ItemData]:
    var items: Array[ItemData] = []
    var dir := DirAccess.open("res://items/")
    if dir:
        dir.list_dir_begin()
        var file_name := dir.get_next()
        while file_name != "":
            if file_name.ends_with(".tres"):
                items.append(load("res://items/" + file_name) as ItemData)
            file_name = dir.get_next()
    return items
```

## Expert: O(1) preload cache

```gdscript
var _cache: Dictionary = {}

func cache_asset(path: String) -> void:
    ResourceLoader.load_threaded_request(path)
    # poll until loaded...
    _cache[path.get_file().get_basename()] = ResourceLoader.load_threaded_get(path)

func get_asset(name: StringName) -> Resource:
    return _cache.get(name)
```

See [resource_preloading_strategy.gd](../scripts/resource_data_patterns_resource_preloading_strategy.gd).

## Expert: local-to-scene components

Mandatory for `HealthComponent` / `AIConfig` sharing one base `.tres` — **"damaging one damages all"** bug without `resource_local_to_scene = true` or `duplicate(true)`.

## Folder layout

```
res://data/
    items/weapons/
    items/consumables/
    characters/
    databases/item_database.tres
```

## Typed arrays

```gdscript
@export var items: Array[ItemData] = []  # ✅
@export var items: Array = []            # ❌
```
