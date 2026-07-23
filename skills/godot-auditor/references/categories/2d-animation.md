# Aurelius Protocol: 2D Animation NEVER List

- **NEVER use AnimatedTexture** — This class is deprecated, highly inefficient in modern renderers, and may be removed in future Godot versions. Use AnimatedSprite2D or AnimationPlayer instead.
- **NEVER allow Tweens to fight over the same property** — If multiple Tweens animate the same property, the last one created forcibly takes priority. Always assign your Tween to a variable and call `kill()` on the previous instance before creating a new one.
- **NEVER process kinematic movement outside the physics tick** — If your AnimationPlayer moves a CharacterBody2D, ensure the AnimationPlayer's callback mode is set to Physics. Animating physics bodies during the Idle (render) frame breaks fixed timestep physics interpolation and causes stutter.
- **NEVER use `animation_finished` for looping animations** — The signal only fires on non-looping animations. Use `animation_looped` instead for loop detection.
- **NEVER call `play()` and expect instant state changes** — AnimatedSprite2D applies `play()` on the next process frame. Call `advance(0)` immediately after `play()` if you need synchronous property updates (e.g., when changing animation + flip_h simultaneously).
- **NEVER set `frame` directly when preserving animation progress** — Setting `frame` resets `frame_progress` to 0.0. Use `set_frame_and_progress(frame, progress)` to maintain smooth transitions when swapping animations mid-frame.
- **NEVER forget to cache `@onready var anim_sprite`** — The node lookup getter is surprisingly slow in hot paths like `_physics_process()`. Always use `@onready`.
- **NEVER mix AnimationPlayer tracks with code-driven AnimatedSprite2D** — Choose one animation authority per sprite. Mixing causes flickering and state conflicts.
- **NEVER use paper-thin skeletons for deformation** — 2D meshes require balanced vertex density. If your mesh deforms poorly, increase the vertex count near joints in the Mesh2D editor.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
