# Aurelius Protocol: Genre Action Rpg NEVER List

- NEVER use linear damage scaling for progression; strictly use an **exponential curve** (e.g., `base * pow(1.15, level)`) to maintain the power fantasy.
- NEVER allow defense stats to stack linearly to 100%; strictly use a **Diminishing Returns** formula (e.g., `armor / (armor + 100.0)`) to prevent invincibility.
- NEVER skip Hit Recovery (Stagger); strictly implement a brief stagger state (0.2s - 0.5s) on significant hits to prevent "floaty" combat.
- NEVER hide critical stats from the player; strictly provide a detailed character sheet for theory-crafting (Crit Chance, Resistance, etc.).
- NEVER make loot drops visually identical; strictly differentiate rarities with color-coded beams (purple/gold) and distinct sound cues.
- NEVER calculate hitboxes, knockbacks, or combat movement in `_process()`; strictly use `_physics_process()` for deterministic results.
- NEVER evaluate exact floating-point equality (==) for combat thresholds; strictly use `is_equal_approx()`.
- NEVER use the ! (NOT) operator in AnimationTree Advance Condition expressions; strictly use explicit boolean equality (`is_walking == false`).
- NEVER store character stats or massive inventories as Nodes; strictly use **Resource-based data containers** for lightweight memory overhead.
- NEVER forget to call `duplicate()` on shared Resources; modifying one goblin's stats must not affect all other instances.
- NEVER rigidly couple combat detection to specific classes; strictly use **Duck-Typing** (e.g., `if body.has_method(&"take_damage")`) for interaction.
- NEVER rely on the UI SceneTree as the source of truth for inventory; strictly separate data logic from visualization.
- NEVER recalculate stats every frame; strictly trigger recalculation only on gear changes or level-ups.
- NEVER parse massive RPG save files synchronously; strictly offload heavy parsing to the `WorkerThreadPool`.
- NEVER synchronize complex Resource types over the network; strictly serialize changes into primitive Dictionaries or PackedByteArrays.
- NEVER manage character state by coupling child nodes to parent existence; strictly use signals for loose coupling ("Signal Up, Call Down").
- NEVER use standard Strings for high-frequency AI state identifiers; strictly use `StringName` for optimized hash comparisons.
- NEVER instantiate/destroy hundreds of objects (projectiles, damage text) per second; strictly use **Object Pooling**.
- NEVER delete active combat entities via `free()`; strictly use `queue_free()` for safe deferred disposal.
- NEVER calculate complex loot drops or parse massive late-game inventories on the main thread; strictly offload heavy RNG rolls and array iterations to the **WorkerThreadPool**.
- NEVER use nested if/elif blocks for complex Boss AI; strictly use a modular **StateMachine** or pattern matching.
- NEVER iterate through the SceneTree for global state changes; strictly use **Signal Groups** (`call_group()`).
- NEVER move `OccluderInstance3D` nodes attached to dynamic characters; this causes CPU BVH rebuild stalls.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
