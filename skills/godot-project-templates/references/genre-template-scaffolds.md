# Genre Template Scaffolds (load on demand)

> **MANDATORY** when copying platformer/RPG/FPS folder trees or wiring stock Autoload snippets. Adapt via genre consumer skills — do not paste FPS controllers or inventory managers verbatim.

## 2D platformer directory

```
my_platformer/
├── autoloads/          # game_manager, audio, scene_transitioner
├── scenes/             # main_menu, game, pause_menu
├── entities/player/
├── levels/
├── ui/
├── audio/
└── resources/data/
```

**game_manager.gd** skeleton — use [base_game_manager.gd](../scripts/base_game_manager.gd):

```gdscript
extends Node
signal game_started
signal game_paused(paused: bool)

func start_game() -> void:
    SceneTransitioner.change_scene("res://levels/level_1.tscn")
    game_started.emit()

func pause_game(paused: bool) -> void:
    get_tree().paused = paused
    game_paused.emit(paused)
```

## Top-down RPG directory

```
my_rpg/
├── autoloads/          # game_data, dialogue, inventory
├── entities/player|npcs|interactables/
├── maps/overworld|dungeons|interiors/
├── systems/combat|dialogue|quests|inventory/
├── ui/
└── resources/items|quests|dialogues/
```

Inventory stub → [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md); template bases only provide folder shape.

## 3D FPS directory

```
my_fps/
├── player/             # player.tscn, camera, weapons/
├── enemies/
├── levels/
└── ui/hud.tscn
```

**FPS movement** belongs in [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — set `Input.MOUSE_MODE_CAPTURED` in player `_ready()`.

## Input map template

```ini
[input]
move_left=Keys: A, Left, Gamepad Left
move_right=Keys: D, Right, Gamepad Right
jump=Keys: Space, Gamepad A
interact=Keys: E, Gamepad X
pause=Keys: Escape, Gamepad Start
```

Use [multi_platform_input.gd](../scripts/multi_platform_input.gd) for device profiles.

## Expert: folder-by-feature

Keep scripts, scenes, textures, and local `.tres` for one entity under `res://entities/<name>/`. Simplifies refactor and asset migration vs monolithic `/scripts`.

## Expert: export presets

- VRAM compression: `import_etc2_astc` for Android; S3TC/BPTC for desktop web/desktop.
- Commit `.import` metadata to VCS.
- Feature tags (`mobile`, `low_end`) via [platform_feature_config.gd](../scripts/platform_feature_config.gd).

## Expert: CI headless export

```yaml
# .github/workflows/export.yml
- run: godot --headless --export-release "Windows Desktop" build/game.exe
```

See [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md).

## Expert: PCK / DLC mount

```gdscript
func load_dlc(path: String) -> void:
    if ProjectSettings.load_resource_pack(path):
        var new_scene = load("res://dlc_level.tscn")
```

**MANDATORY** [modular_dlc_loader.gd](../scripts/modular_dlc_loader.gd).

## Expert: bootstrap priority

Replace linear Autoload list with prioritized boot — [bootstrap_config.gd](../scripts/bootstrap_config.gd): config/network before audio/UI.

## Godot 4.7 defaults

Stretch mode `canvas_items`, aspect `expand` — document overrides in `project.godot` if legacy `disabled`/`keep` behavior is required.
