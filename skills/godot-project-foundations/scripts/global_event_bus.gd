## Global Event Bus (Autoload: EventBus)
## Strongly-typed Signal Bus for system decoupling.
## Allows nodes to communicate without direct dependencies.
extends Node

# Expert: Group signals by domain for clarity
# --- Player Signals ---
signal player_spawned(player: Node2D)
signal player_died(reason: StringName)
signal player_health_changed(current: int, max: int)

# --- World Signals ---
signal level_started(id: StringName)
signal level_completed(id: StringName)

# --- System Signals ---
signal save_requested
signal settings_updated(config: Dictionary)

## Tip: Use StringName (&"name") for signal parameters to avoid string overhead.
## Tip: Always include 'player' or 'sender' references if multiple instances exist.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — typed bus connect/disconnect lifetime
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — register EventBus without monolithic managers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
