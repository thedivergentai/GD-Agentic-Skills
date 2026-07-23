# Advanced AnimationTree Graph Recipes

> **Do NOT Load by default.** Open only when implementing nested combat graphs, IK look-at beside the tree, or deep BlendTree layering after the golden path scripts fail to cover the case.

## Nested StateMachines

Locomotion root StateMachine → Combat / Airborne sub-machines. Parameter paths stay relative (`parameters/Locomotion/Combat/playback`). Prefer [nested_state_machine.gd](../scripts/animation_tree_mastery_nested_state_machine.gd) and [nested_tree_architecture.gd](../scripts/animation_tree_mastery_nested_tree_architecture.gd).

## BlendTree layering checklist

1. Lower body: BlendSpace1D/2D or locomotion StateMachine.
2. Upper body: `AnimationNodeAdd2` / `Blend2` with filter mask ([advanced_transition_masking.gd](../scripts/animation_tree_mastery_advanced_transition_masking.gd)).
3. Overlays: `AnimationNodeOneShot` ([reactive_oneshot_vfx.gd](../scripts/animation_tree_mastery_reactive_oneshot_vfx.gd)).
4. Sync groups only when clip lengths match ([sync_group_layering.gd](../scripts/animation_tree_mastery_sync_group_layering.gd)).

## Skeleton IK / LookAt

Drive look-at beside the tree with LookAtModifier3D; do not fight AnimationTree bone tracks. See [skeleton_ik_lookat.gd](../scripts/animation_tree_mastery_skeleton_ik_lookat.gd). Godot 4.7: `LookAtModifier3D.relative` default is `false`.

## Root motion

Extract via AnimationTree getters, apply on CharacterBody — [root_motion_animtree_sync.gd](../scripts/animation_tree_mastery_root_motion_animtree_sync.gd).

## Debug / cull

- Live state/blend inspect: [runtime_tree_debugging.gd](../scripts/animation_tree_mastery_runtime_tree_debugging.gd)
- Swap `tree_root` hero vs crowd when off-screen to cut CPU.
