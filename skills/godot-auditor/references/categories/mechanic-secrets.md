# Aurelius Protocol: Mechanic Secrets NEVER List

- **NEVER hardcode input checks in `_process`** — Frame-dependent polling is unreliable for fast combos. Always use an event-based buffer like `secret_sequence_combo_matcher.gd`.
- **NEVER use complex Raycasts for 'LookingAt' secrets** — Physics raycasts are expensive if every wall is checking. Use the Dot Product method in `secret_visibility_detector.gd` for overhead efficiency.
- **NEVER make 'Hidden Walls' identical to real walls** — Players need a subtle "Glimmer" or texture discrepancy. Total invisibility isn't a secret; it's a bug to the player.
- **NEVER save "Secrets Found" in the main Save Slot** — If the player deletes their save to try a different build, their meta-progress (Gallery, Achievement flags) should persist. Use `secret_meta_persistence.gd`.
- **NEVER trust client-side cheat validation in Peer-to-Peer** — If a secret grants a stat boost, other peers should validate the "Unlock" to prevent simple memory-editing cheats.
- **NEVER use `PlayerPrefs` (Godot's equivalent of Settings) for secrets** — Use a dedicated `user://secrets.cfg`.
- **NEVER allow unlimited rapid-fire cheat attempts** — A simple macro can brute-force a 4-button combo in seconds. Use `secret_lockout_cheat_guard.gd` to add a penalty for excessive failures.
- **NEVER trigger a secret without an 'Aha!' audio/visual cue** — The reward for finding a secret is the *feeling* of discovery. Use `secret_audio_environment_occluder.gd` to change the atmosphere.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
