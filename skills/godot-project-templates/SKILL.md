---
name: godot-project-templates
description: "Navigation skill for genre project scaffolds: pick platformer/RPG/FPS (or other genre) then load matching template scripts and route gameplay fill to godot-genre-* skills. Use when bootstrapping architecture, bootstrap order, pause modes, PCK DLC, or feature tags — not for pasting FPS/inventory recipes. Keywords: project templates, bootstrap, Subsystem Locator, PCK, feature tags, PROCESS_MODE_ALWAYS, genre scaffold."
---

# Project Templates (Navigation)

Scaffold architecture, then **adapt** — never dump genre tutorials into the project verbatim.

## NEVER Do (Expert Anti-Patterns)

### Directory & Scaffolding
- **NEVER hardcode scene paths** in dozens of call sites — AutoLoad constants or a scene registry.
- **NEVER skip `.gdignore` for designer asset drops** outside import pipelines.
- **NEVER copy-paste templates as-is** — Understand structure, then adapt (see checklist below).

### Architecture & Lifecycle
- **NEVER use `get_tree().paused` without process-mode groups** — Pause menus need `PROCESS_MODE_ALWAYS`. **Why:** pausing the tree freezes `_process` on menu nodes too, so buttons never receive input; set gameplay to `INHERIT` (paused) and menu/HUD to `ALWAYS` via [base_menu.gd](scripts/base_menu.gd) or explicit `process_mode` on the pause root.
- **NEVER skip virtual lifecycle hooks** on base classes — Prefer `_initialize_*()` over brittle `_ready()` overrides.
- **NEVER rely on monolithic God singletons** — Signal Bus or **Subsystem Locator**.

### Platform & UI
- **NEVER skip `Input.MOUSE_MODE_CAPTURED` in FPS scaffolds** — Set when the FPS genre path is chosen.
- **NEVER use floating-point constants for UI layout** — Anchors/containers.
- **NEVER ignore i18n translation context** — Disambiguate strings in `tr()` / contexts.

### Performance
- **NEVER load massive levels synchronously** — `ResourceLoader.load_threaded_request()`.

---

## Golden Path

0. **Bootstrap** — **MANDATORY** [bootstrap_config.gd](scripts/bootstrap_config.gd): config/network before audio/UI (do not rely on accidental Autoload order).
1. Pick a genre row below → load listed scripts only.
2. Rename project, register locator/bootstrap, configure Input Map.
3. Open the consumer `godot-genre-*` skill for gameplay systems.

**Platformer end-to-end:** row 1 scripts → [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) (`advanced_platformer_controller.gd` for movement; template `base_level` + state machine for scene flow). **Do NOT** paste FPS/inventory recipes from this skill.

## Genre Router → Scripts

> **MANDATORY**: Choose a genre row, load the listed scripts, then open the consumer `godot-genre-*` skill for gameplay systems. **Do NOT** paste inline FPS controllers or inventory managers from memory.

| Genre intent | Load these template scripts (MANDATORY) | Fill gameplay via |
| :--- | :--- | :--- |
| 2D platformer | [base_game_manager.gd](scripts/base_game_manager.gd), [base_level.gd](scripts/base_level.gd), [base_actor.gd](scripts/base_actor.gd), [scene_state_machine.gd](scripts/scene_state_machine.gd), [state_machine_node.gd](scripts/state_machine_node.gd) | [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) |
| Top-down / action RPG | Same bases + [subsystem_locator.gd](scripts/subsystem_locator.gd), [base_menu.gd](scripts/base_menu.gd) | [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) |
| 3D FPS / shooter | Bases + [multi_platform_input.gd](scripts/multi_platform_input.gd), [platform_feature_config.gd](scripts/platform_feature_config.gd) | [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) |
| Any genre + DLC packs | [modular_dlc_loader.gd](scripts/modular_dlc_loader.gd) | Genre skill + [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) |
| Cross-platform input/features | [multi_platform_input.gd](scripts/multi_platform_input.gd), [platform_feature_config.gd](scripts/platform_feature_config.gd) | [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) |
| Threaded level streaming | [level_steamer_manager.gd](scripts/level_steamer_manager.gd) | [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) |
| Accessibility TTS | [accessibility_tts_manager.gd](scripts/accessibility_tts_manager.gd) | Project foundations / UI skills |

Folder-by-feature skeleton (all genres): `entities/<name>/`, `levels/` or `maps/`, `ui/`, `autoloads/` or locator-registered systems, `resources/`. Details belong in the genre consumer skill — not duplicated here.

---

## Architecture Deltas (keep in this skill)

### Godot 4.7 project defaults
- Stretch **mode**: `canvas_items` (was `disabled`); **aspect**: `expand` (was `keep`). Document overrides if legacy behavior is required.

### Subsystem Locator vs God Autoload
Prefer [subsystem_locator.gd](scripts/subsystem_locator.gd) for modular registration; keep a thin bootstrap Autoload only.

### Bootstrap order
**MANDATORY** [bootstrap_config.gd](scripts/bootstrap_config.gd) (or equivalent): critical systems (config/network) before audio/UI. Do not rely on accidental Project Settings Autoload order alone.

### Pause modes
Gameplay tree pauses; UI/pause menu nodes use `PROCESS_MODE_ALWAYS`. Wire via [base_menu.gd](scripts/base_menu.gd).

### PCK / DLC
**MANDATORY** [modular_dlc_loader.gd](scripts/modular_dlc_loader.gd) for `ProjectSettings.load_resource_pack()` mounts — never hand-roll path hacks in gameplay code.

### Feature tags
**MANDATORY** [platform_feature_config.gd](scripts/platform_feature_config.gd) for `OS.has_feature()` / export-tag forks (mobile, low_end, dedicated_server).

---

## Adapt-Not-Copy Checklist

Map each template piece to a consumer skill before writing gameplay code:

| Template piece | Adapt into |
| :--- | :--- |
| `base_actor` / state machine nodes | Genre movement/combat skill (`godot-genre-*`) + [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) |
| `base_game_manager` signals | [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) / [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) |
| Level streamer | [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) |
| Input / feature config | [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) + platform skills |
| Menus / HUD shells | [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) |
| Export / CI / PCK | [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) |

**Usage:** pick genre row → load scripts → rename project → register locator/bootstrap → configure Input Map → open genre skill for systems — do not paste stock FPS/inventory recipes from this skill.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Project organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html) — Feature-folder layouts, `.gdignore`, and VCS hygiene that genre boilerplates should bake in from day one.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Ownership boundaries for `entities/`, `levels/`, and UI scenes so templates stay refactor-safe.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Registering lean GameManager / Audio / SceneTransitioner services that survive scene changes.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — When a Subsystem Locator or scene-local node beats a monolithic God singleton.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_*` patterns used by level streamer templates.
- [Pausing games](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html) — Process modes so pause menus stay alive while gameplay freezes.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch mode/aspect defaults (`canvas_items` / `expand`) every new project template should document.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — `OS.has_feature()` profiles for mobile/PC/server overrides in platform config templates.
- [Exporting packs (PCK)](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) — Modular DLC / patch mounts via `ProjectSettings.load_resource_pack()`.
- [Using controllers and gamepads](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Default Input Map actions and deadzone tuning for multi-platform templates.
- [Text-to-speech](https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html) — DisplayServer TTS hooks for accessibility manager scaffolding.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — Translation contexts so UI strings in menus/HUD avoid ambiguous keys.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Folder hygiene, naming, and import basics before copying a genre skeleton into a real repo.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed base classes, virtual hooks, and signal style used by every template script here.

#### Complements
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Boot order and ownership rules once BootstrapConfig / GameManager Autoloads leave the template stage.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Production scene swaps and load queues that deepen the level streamer boilerplate.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Full action maps, device routing, and remapping beyond MultiPlatformInput scaffolding.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Hierarchical / visual FSM patterns that extend SceneStateMachine and StateMachineNode.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Export presets, VRAM compression, and CI headless flags assumed by Standard-Export-Presets templates.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Typed EventBus patterns when templates grow past direct GameManager signals.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Anchor/container layouts for BaseMenu and HUD scenes instead of floating-point pixel drift.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Touch, safe-area, and mobile feature-tag profiles that PlatformFeatureConfig only stubs.

#### Downstream / consumers
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — Fills the 2D platformer directory skeleton with movement, coyote time, and level flow.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Combat, inventory, and quest systems that plug into the top-down RPG template folders.
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — Weapons, hit detection, and camera feel layered on the 3D FPS player scaffold.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
