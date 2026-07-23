# Aurelius Protocol: Genre Puzzle NEVER List

- NEVER punish experimentation; strictly provide **Undo/Reset** functionality to allow risk-free hypothesis testing.
- NEVER require pixel-perfect input for logic puzzles; strictly use **Grid Snapping** or large, forgiving hitboxes.
- NEVER allow undetected **Soft-Locks** (unsolvable states); strictly notify the player or provide immediate backtracking.
- NEVER hide the rules of the world; strictly ensure visual feedback is instant and unambiguous (e.g., powered wires must glow).
- NEVER skip the **Non-Verbal Tutorial** phase; strictly introduce mechanics in isolation before combining them.
- NEVER use floating-point numbers (`Vector2`) for grid coordinates; strictly use **Vector2i** to prevent precision drift.
- NEVER use `_process()` for grid-state or win-condition validation; strictly trigger checks only when a piece moves.
- NEVER rely on the `SceneTree` structure as the source of truth; strictly maintain grid data in a separate script/dictionary.
- NEVER modify a Dictionary or Array size while iterating over it; strictly use a copy or a separate queue for modifications.
- NEVER calculate heavy recursive solvers in `_process()`; strictly cache results or use threaded workers for solve-checks.
- NEVER ignore diagonal rules in pathfinding; strictly configure `AStarGrid2D.diagonal_mode` correctly.
- NEVER program custom command history queues manually; strictly use Godot's built-in **UndoRedo** system for reliability.
- NEVER intermingle "do" and "undo" logic in the same function; strictly maintain separation for predictable rollbacks.
- NEVER use exact floating-point equality (==); strictly use `is_equal_approx()` for spatial constraints.
- NEVER use `load()` for resetting large rooms dynamically; strictly use `ResourceLoader.load_threaded_request()`.
- NEVER leave **Tween** objects unreferenced; strictly kill active tweens before starting new movement on the same object.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
