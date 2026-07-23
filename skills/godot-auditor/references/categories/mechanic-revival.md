# Aurelius Protocol: Mechanic Revival NEVER List

- **NEVER respawn the player with existing velocity** — Always zero out `velocity` and `angular_velocity` in `revival_state_reset_guard.gd` or the player will fly into a wall upon respawning.
- **NEVER trust the nearest checkpoint by distance** — Always use a 'Progress Index' (`revival_checkpoint_validator.gd`). Players in non-linear games may wander back to the start area; don't downgrade their respawn point.
- **NEVER skip 'Invincibility Frames' (I-frames)** — Respawning inside a hazard or near an enemy without a 2s invincibility buffer leads to "Death Loops" and player frustration.
- **NEVER save checkpoints solely in RAM** — If the game crashes, the player loses progress. Use `revival_checkpoint_persistence.gd` to write to `user://` immediately.
- **NEVER hardcode checkpoint coordinates** — Use `Marker3D` or `Area3D` nodes in the scene. Hardcoded coords break as soon as level geometry changes.
- **NEVER delete the player node on death** — `queue_free()`ing the player breaks UI refs and references from enemies. Disable processing, hide the mesh, and 'Revive' the existing instance instead.
- **NEVER respawn instantly** — An instant snap is disorienting. Always use a 1-2s delay with a screen fade or death animation to allow the player to process the failure.
- **NEVER reset the entire world on player death** — In modern design, opened doors and collected unique items should stay persisted. Use a bitmask in the checkpoint resource to track 'World Progress'.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
