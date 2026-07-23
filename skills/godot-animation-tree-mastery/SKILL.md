---
name: godot-animation-tree-mastery
description: "Expert patterns for AnimationTree including StateMachine transitions, BlendSpace2D for directional movement, BlendTree for layered animations, root motion, transition conditions, advance expressions, and state machine sub-states. Use for complex character animation systems with movement blending and state management. Trigger keywords: AnimationTree, AnimationNodeStateMachine, BlendSpace2D, BlendSpace1D, BlendTree, transition_request, blend_position, advance_expression, AnimationNodeAdd2, AnimationNodeBlend2, root_motion."
---

# AnimationTree Mastery

Expert guidance for Godot's advanced animation blending and state machines.

## NEVER Do

- **NEVER call `play()` on AnimationPlayer when using AnimationTree** — AnimationTree controls the player. Directly calling `play()` causes conflicts and jitter. Use `set("parameters/transition_request")` or `travel()` instead.
- **NEVER forget to set `active = true`** — AnimationTree is inactive by default. Animations won't play until `$AnimationTree.active = true`.
- **NEVER use absolute paths for parameter access** — Use relative paths like `"parameters/StateMachine/transition_request"`. This ensures compatibility when nodes move in the hierarchy.
- **NEVER leave `auto_advance` enabled for interactive states** — It causes immediate transitions. Use it only for automated sequences like combo chains or death-to-respawn.
- **NEVER use `BlendSpace2D` for 1D blending** — Blending only speed? Use `BlendSpace1D`. Blending only two states? Use `Blend2`. `BlendSpace2D` is specifically for X+Y directional inputs (strafe).
- **NEVER update `AnimationTree` parameters every frame without a guard** — Setting parameters via `set()` every frame regardless of change causes cache invalidation and potential stutter. Check equality first.
- **NEVER use deep, nested `BlendTrees` for simple logic** — Every layer adds CPU overhead. If logic can be handled in a `StateMachine` or a simple script-driven `Blend2`, do it there.
- **NEVER forget to handle `await get_tree().process_frame` when updating parameters synchronously** — Sometimes the tree needs one frame to reconcile state before the next parameter change takes effect.
- **NEVER rely on `auto_advance` for long cutscenes** — If an animation is interrupted, `auto_advance` can put the character in a broken state. Use `Method Tracks` to signal state completion instead.
- **NEVER use `Sync` groups for animations with wildly different lengths** — It forces one animation to play at an extreme speed. Use `TimeScale` or separate layers for mismatching cycles.

---

## Godot 4.7: AnimationTree

- `LookAtModifier3D.relative` default is now **false** (was true).
- Blend space `add_blend_point` accepts optional **name** parameter for labeled points.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.
> **Do NOT Load** [references/advanced-graph-recipes.md](references/advanced-graph-recipes.md) unless nested combat graphs, IK look-at, or deep BlendTree layering are in scope.

### [sync_parameter_manager.gd](scripts/sync_parameter_manager.gd)
Guarded `AnimationTree` parameter writes — prevent redundant `set()` churn every physics frame.

### [statemachine_travel_code.gd](scripts/statemachine_travel_code.gd)
Programmatic `AnimationNodeStateMachinePlayback` via `travel()` / `start()`.

### [tree_travel_manager.gd](scripts/tree_travel_manager.gd)
**Trigger: multi-machine travel / request queue.** Centralizes travel requests across nested playback paths without calling AnimationPlayer.`play()`.

### [nested_state_machine.gd](scripts/nested_state_machine.gd)
**Trigger: locomotion + combat (or air) sub-machines.** Nested StateMachine parameter paths and playback handoff.

### [skeleton_ik_lookat.gd](scripts/skeleton_ik_lookat.gd)
**Trigger: aim/look-at beside the tree.** LookAtModifier3D / IK that must not fight bone tracks the tree owns.

### [reactive_oneshot_vfx.gd](scripts/reactive_oneshot_vfx.gd)
`AnimationNodeOneShot` for recoil, blinks, and hit reactions.

### [dynamic_timescale_control.gd](scripts/dynamic_timescale_control.gd)
Runtime playback speed for bullet-time or haste multipliers.

### [advanced_transition_masking.gd](scripts/advanced_transition_masking.gd)
Bone filter masks on Add2/Blend2 for upper/lower body separation.

### [blendtree_logic_mixing.gd](scripts/blendtree_logic_mixing.gd)
Interactive combat layer mixing inside BlendTree graphs.

### [root_motion_animtree_sync.gd](scripts/root_motion_animtree_sync.gd)
CharacterBody motion extraction from AnimationTree root motion.

### [sync_group_layering.gd](scripts/sync_group_layering.gd)
Sync groups for multi-layer clips that share length (e.g. walk + reload).

### [nested_tree_architecture.gd](scripts/nested_tree_architecture.gd)
Hierarchical StateMachine / nested parameter path architecture.

### [runtime_tree_debugging.gd](scripts/runtime_tree_debugging.gd)
Visualize current states, travel paths, and blend values at runtime.

---

## Decision Tree (replace inline tutorials)

| Need | Prefer | Script |
|------|--------|--------|
| Simple clip swap / UI / prop | AnimationPlayer only | Peer godot-animation-player |
| 5+ gameplay states, travel | StateMachine root | [statemachine_travel_code.gd](scripts/statemachine_travel_code.gd), [tree_travel_manager.gd](scripts/tree_travel_manager.gd) |
| Speed only blend | BlendSpace1D | Guarded writes via [sync_parameter_manager.gd](scripts/sync_parameter_manager.gd) |
| Strafe / aim X+Y | BlendSpace2D | Same + `blend_position` |
| Upper-body overlay / combat layer | BlendTree Add2/Blend2/OneShot | [blendtree_logic_mixing.gd](scripts/blendtree_logic_mixing.gd), [reactive_oneshot_vfx.gd](scripts/reactive_oneshot_vfx.gd) |
| Nested combat/air under locomotion | Nested SM | **MANDATORY** [nested_state_machine.gd](scripts/nested_state_machine.gd) |
| Look-at / IK | Modifier beside tree | **MANDATORY** [skeleton_ik_lookat.gd](scripts/skeleton_ik_lookat.gd) |
| Deep graph recipes | references/ | **Do NOT Load** unless needed → [advanced-graph-recipes.md](references/advanced-graph-recipes.md) |

**Core Concepts (compact):** AnimationTree owns an AnimationPlayer via `anim_player`; root is StateMachine / BlendTree / BlendSpace; parameters use relative `"parameters/..." ` paths; set `active = true` once in `_ready`.

```gdscript
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/StateMachine/playback")

func _ready() -> void:
    anim_tree.active = true
```

Do not paste full StateMachine/BlendSpace editor walkthroughs — author graphs in the AnimationTree editor, then drive them with the scripts above.

---

## Expert Pattern: Animation-Event-Dispatcher

Decouple Method Track keys from gameplay via a signal dispatcher (`dispatch_event(name, metadata)`). Audio/VFX listen; the tree keeps playing.

## Expert Pattern: Tree-Complexity-Culler

Swap `AnimationTree.tree_root` between a complex hero graph and a simple crowd loop using `VisibleOnScreenNotifier3D` to cut off-screen CPU.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — Canonical BlendTree / StateMachine / BlendSpace graph workflow that drives an AnimationPlayer without calling `play()` yourself.
- [Introduction to the animation features](https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html) — When to graduate from AnimationPlayer-only clips to an AnimationTree for blending, travel, and layered presentation.
- [Animation track types](https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html) — Method and value tracks that fire gameplay events (footsteps, hitboxes) from clips the tree is already blending.
- [AnimationTree](https://docs.godotengine.org/en/stable/classes/class_animationtree.html) — `active`, `tree_root`, `anim_player`, root-motion getters, and the `parameters/*` path contract used throughout this skill.
- [AnimationNodeStateMachine](https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachine.html) — Authoring nested locomotion/combat graphs and wiring transitions before code calls `travel()`.
- [AnimationNodeStateMachinePlayback](https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html) — Runtime `travel()`, `start()`, `get_current_node()`, and travel-path inspection for code-driven state changes.
- [AnimationNodeStateMachineTransition](https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachinetransition.html) — Advance conditions, `auto_advance`, Sync, xfade, and priority rules that prevent sticky or immediate unwanted transitions.
- [AnimationNodeBlendSpace2D](https://docs.godotengine.org/en/stable/classes/class_animationnodeblendspace2d.html) — Directional strafe/aim blending via `blend_position` (use BlendSpace1D when only speed is needed).
- [AnimationNodeBlendTree](https://docs.godotengine.org/en/stable/classes/class_animationnodeblendtree.html) — Layered Add2/Blend2/OneShot graphs for upper-body aim, combat overlays, and filter masks.
- [AnimationNodeOneShot](https://docs.godotengine.org/en/stable/classes/class_animationnodeoneshot.html) — FIRE/ABORT request enum for recoil, hitreact, and other high-priority non-looping overlays.
- [AnimationNodeTimeScale](https://docs.godotengine.org/en/stable/classes/class_animationnodetimescale.html) — Per-subtree playback speed for haste, stun, and bullet-time without mutating Engine.time_scale.
- [LookAtModifier3D](https://docs.godotengine.org/en/stable/classes/class_lookatmodifier3d.html) — Skeleton look-at driven beside the tree; note Godot 4.7 `relative` default change called out above.

### Related Skills

#### Prerequisites
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — AnimationTree owns playback of clips authored on AnimationPlayer; track layout and ownership must be correct before blending.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Stick/keyboard vectors and actions that feed `blend_position`, advance conditions, and travel targets each physics frame.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Safe wiring for method-track dispatchers and animation-finished style signals without lifecycle leaks.

#### Complements
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — Sheet/cutout and 2D locomotion presentation that still uses AnimationTree BlendSpaces or simple travel graphs.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Gameplay FSMs that should own intent while AnimationTree owns presentation travel and blends.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — CharacterBody3D / move_and_slide integration for AnimationTree root-motion extraction.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Fixed-timestep 2D locomotion inputs that drive StateMachine travel and BlendSpace positions.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Tweening TimeScale or blend amounts when bullet-time and combat mix ramps should be interruptible.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hitreact/combo layers that consume OneShot requests, upper-body Add2 masks, and nested combat sub-machines.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Profiling and logging discipline when validating travel paths, blend values, and off-screen `active` culling.

#### Downstream / consumers
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Locomotion + combat stance trees and ability cast OneShots built on these graph patterns.
- [godot-genre-fighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md) — Frame-sensitive combo auto-advance and masked upper-body attacks depend on transition and BlendTree discipline here.
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — Aim/reload overlays, recoil OneShots, and look-at modifiers layered over locomotion BlendSpaces.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
