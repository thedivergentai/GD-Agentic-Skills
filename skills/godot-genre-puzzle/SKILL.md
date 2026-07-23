---
name: godot-genre-puzzle
description: "Expert blueprint for puzzle games including undo systems (Command pattern for state reversal), grid-based logic (Sokoban-style mechanics), non-verbal tutorials (teach through level design), win condition checking, state management, and visual feedback (instant confirmation of valid moves). Use for logic puzzles, physics puzzles, or match-3 games. Trigger keywords: puzzle_game, undo_system, command_pattern, grid_logic, non_verbal_tutorial, state_management."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Puzzle

Expert blueprint for puzzle games emphasizing clarity, experimentation, and "Aha!" moments.

## NEVER Do (Expert Anti-Patterns)

### Design & Player Experience
- NEVER punish experimentation; strictly provide **Undo/Reset** functionality to allow risk-free hypothesis testing.
- NEVER require pixel-perfect input for logic puzzles; strictly use **Grid Snapping** or large, forgiving hitboxes.
- NEVER allow undetected **Soft-Locks** (unsolvable states); strictly notify the player or provide immediate backtracking.
- NEVER hide the rules of the world; strictly ensure visual feedback is instant and unambiguous (e.g., powered wires must glow).
- NEVER skip the **Non-Verbal Tutorial** phase; strictly introduce mechanics in isolation before combining them.

### Grid Logic & State
- NEVER use floating-point numbers (`Vector2`) for grid coordinates; strictly use **Vector2i** to prevent precision drift.
- NEVER use `_process()` for grid-state or win-condition validation; strictly trigger checks only when a piece moves.
- NEVER rely on the `SceneTree` structure as the source of truth; strictly maintain grid data in a separate script/dictionary.
- NEVER modify a Dictionary or Array size while iterating over it; strictly use a copy or a separate queue for modifications.
- NEVER calculate heavy recursive solvers in `_process()`; strictly cache results or use threaded workers for solve-checks.
- NEVER ignore diagonal rules in pathfinding; strictly configure `AStarGrid2D.diagonal_mode` correctly.

### Architecture & Performance
- NEVER ship dual undo authorities; strictly use Godot's built-in **UndoRedo** via [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd) — do **not** also maintain a hand-rolled Command stack.
- NEVER intermingle "do" and "undo" logic in the same function; strictly maintain separation for predictable rollbacks.
- NEVER use exact floating-point equality (==); strictly use `is_equal_approx()` for spatial constraints.
- NEVER use `load()` for resetting large rooms dynamically; strictly use `ResourceLoader.load_threaded_request()`.
- NEVER leave **Tween** objects unreferenced; strictly kill active tweens before starting new movement on the same object.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd) — sole undo authority (`UndoRedo`)
> 2. [grid_manager.gd](scripts/grid_manager.gd) — Vector2i grid as truth
> 3. [puzzle_state_validator.gd](scripts/puzzle_state_validator.gd) — soft-lock / win checks on commit

### Original Expert Patterns
- [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd) - Godot `UndoRedo` wrapper for move do/undo (golden path).

### Modular Components
- [grid_manager.gd](scripts/grid_manager.gd) - Vector2i board state decoupled from SceneTree.
- [grid_tween_mover.gd](scripts/grid_tween_mover.gd) - Kill-before-recreate Tweens for piece moves.
- [puzzle_state_validator.gd](scripts/puzzle_state_validator.gd) - Win / soft-lock validation after commits.
- [grid_input_manager.gd](scripts/grid_input_manager.gd) - Snapped grid input.
- [match_three_logic.gd](scripts/match_three_logic.gd) - Match-3 resolve / cascade helpers.
- [puzzle_pathfinder.gd](scripts/puzzle_pathfinder.gd) - `AStarGrid2D` hints (`diagonal_mode`).
- [puzzle_saver.gd](scripts/puzzle_saver.gd) - Level / snapshot serialization.
- [puzzle_validator.gd](scripts/puzzle_validator.gd) - Broader solvability checks.
- [puzzle_history.gd](scripts/puzzle_history.gd) - Thin UndoRedo action helpers (complements undo manager).
- [tile_animator.gd](scripts/tile_animator.gd) - Tile juice without owning state.
- [shuffle_bag.gd](scripts/shuffle_bag.gd) - Fair random piece bags.
- [perspective_overlay.gd](scripts/perspective_overlay.gd) - Perspective / overlay puzzles.
- [sleepy_block.gd](scripts/sleepy_block.gd) - Timed / sleeping block mechanic sample.

> **Do NOT load** [command_undo_redo.gd](scripts/command_undo_redo.gd) — legacy hand-rolled Command stack superseded by `UndoRedo`.

---

## Core Loop
1. **Observe** → 2. **Hypothesize** → 3. **Commit move** → 4. **Validate** → 5. **Undo/Reset** if needed

## Decision Trees

### Genre → scripts
| Puzzle type | MANDATORY reads |
|-------------|-----------------|
| Sokoban / push grid | [grid_manager.gd](scripts/grid_manager.gd), [grid_tween_mover.gd](scripts/grid_tween_mover.gd), [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd), [puzzle_state_validator.gd](scripts/puzzle_state_validator.gd) |
| Match-3 | [match_three_logic.gd](scripts/match_three_logic.gd), [grid_tween_mover.gd](scripts/grid_tween_mover.gd), [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd) |
| Physics / spatial | Snap on settle → then same undo/validator path; do not treat rigid bodies as truth |
| Hints / solvers | [puzzle_pathfinder.gd](scripts/puzzle_pathfinder.gd) (`AStarGrid2D.diagonal_mode`) |

### Undo authority
| Need | Action |
|------|--------|
| Player undo/redo | **Only** [puzzle_undo_manager.gd](scripts/puzzle_undo_manager.gd) |
| Level editor history | Still `UndoRedo` — wrap editor actions the same way |

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Data | `dictionaries`, `resources` | Grid truth, level `.tres` |
| 2. Input | `godot-input-handling` | Snapped moves |
| 3. Motion | `godot-tweening` | Piece Tweens |
| 4. AI/hints | `godot-navigation-pathfinding` | A* hints |
| 5. Persist | `godot-save-load-systems` | Level / progress |

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Dual undo APIs | Delete Command-stack path; use UndoRedo manager only |
| Win check in `_process` | Validate on move commit via state validator |
| Float grid coords | `Vector2i` only |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [UndoRedo](https://docs.godotengine.org/en/stable/classes/class_undoredo.html) — Built-in action history for do/undo/redo so puzzle experimentation does not require a hand-rolled command stack.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — Uniform-grid pathfinding (`diagonal_mode`, `jumping_enabled`) for hints and reachability on Sokoban-style boards.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Interruptible `create_tween()` motion for cell-to-cell feedback while logical `Vector2i` state updates immediately.
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer workflows for painting walls/targets while keeping puzzle truth in a separate grid dictionary.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist level progress, stars, and mid-puzzle snapshots without relying on scene reload as save.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Device-agnostic click/drag/action routing for forgiving grid selection and move commits.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Store layouts and starting piece sets as `.tres`/`Resource` data editable in the Inspector.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — RigidBody sleep, layers, and integration hooks for physics-driven puzzle pieces.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Why win/soft-lock checks belong on move commits, not every `_process` frame.
- [Data preferences](https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html) — Prefer integer grid keys (`Vector2i`) and explicit dictionaries over SceneTree-as-truth.
- [Runtime file loading and saving](https://docs.godotengine.org/en/stable/tutorials/io/runtime_file_loading_and_saving.html) — `FileAccess`/`user://` patterns for custom level JSON and editor export packs.
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Serialize compact puzzle boards when splitting `Vector2` fields for portable level files.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Buffered InputEvent/action maps so grid clicks and directional moves stay device-agnostic and forgiving.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Safe `state_changed` / `level_complete` wiring so UI and VFX stay decoupled from grid truth.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoload/project layout baselines before stacking undo managers, savers, and level packs.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Deeper Tween composition when cell moves, match clears, and resets need interruptible juice without logic races.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Progress ownership, versioning, and threaded loads beyond per-level JSON snapshots.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMapLayer painting, custom data, and terrain patterns that visualize walls while scripts own solvability.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Broader Navigation/A* stacks when puzzle hints outgrow a single `AStarGrid2D` region.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — RigidBody sleep, layers, and queries for physics puzzles that still need deterministic settle/win checks.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Phase FSMs (observe → move → resolve → win) when puzzles mix animation locks with input gates.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera2D/3D framing and unproject helpers for perspective/world-space puzzle overlays.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Minimal undo/reset HUD layouts that stay non-intrusive during non-verbal tutorials.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Sample solvability, move-count distributions, and soft-lock rates so level packs stay fair as mechanics combine.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Generate candidate boards that still pass this skill's validators, undo constraints, and win-condition contracts.
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — Consumes grid/undo patterns when dungeon runs embed discrete puzzle rooms or locked-door logic.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this genre skill beside sibling domains.
