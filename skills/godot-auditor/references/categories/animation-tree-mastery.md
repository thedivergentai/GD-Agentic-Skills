# Aurelius Protocol: Animation Tree Mastery NEVER List

- **NEVER call `play()` on AnimationPlayer when using AnimationTree** — AnimationTree controls the player. Directly calling `play()` causes conflicts and jitter. Use `set("parameters/transition_request")` or `travel()` instead [12].
- **NEVER forget to set `active = true`** — AnimationTree is inactive by default. Animations won't play until `$AnimationTree.active = true` [13].
- **NEVER use absolute paths for parameter access** — Use relative paths like `"parameters/StateMachine/transition_request"`. This ensures compatibility when nodes move in the hierarchy [14].
- **NEVER leave `auto_advance` enabled for interactive states** — It causes immediate transitions. Use it only for automated sequences like combo chains or death-to-respawn [15, 121].
- **NEVER use `BlendSpace2D` for 1D blending** — Blending only speed? Use `BlendSpace1D`. Blending only two states? Use `Blend2`. `BlendSpace2D` is specifically for X+Y directional inputs (strafe) [16, 142].
- **NEVER update `AnimationTree` parameters every frame without a guard** — Setting parameters via `set()` every frame regardless of change causes cache invalidation and potential stutter. Check equality first.
- **NEVER use deep, nested `BlendTrees` for simple logic** — Every layer adds CPU overhead. If logic can be handled in a `StateMachine` or a simple script-driven `Blend2`, do it there.
- **NEVER forget to handle `await get_tree().process_frame` when updating parameters synchronously** — Sometimes the tree needs one frame to reconcile state before the next parameter change takes effect.
- **NEVER rely on `auto_advance` for long cutscenes** — If an animation is interrupted, `auto_advance` can put the character in a broken state. Use `Method Tracks` to signal state completion instead.
- **NEVER use `Sync` groups for animations with wildly different lengths** — It forces one animation to play at an extreme speed. Use `TimeScale` or separate layers for mismatching cycles.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
