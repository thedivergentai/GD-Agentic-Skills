# skills/autoload-architecture/code/stateless_bus.gd
extends Node

## Stateless Signal Bus Expert Pattern
## Optimized for decoupling and lazy-loading of systems.

# 1. Defined Semantic Signals
# Avoid 'generic' signals. Be specific about the domain.
signal player_health_changed(new_health: int, max_health: int)
signal level_completed(id: String, score: int)
signal system_booted(id: String)

func _ready() -> void:
    # 2. Boot-time Priorities
    # Autoloads initialize in order. Use signals to notify
    # other singletons that this generic hub is ready.
    system_booted.emit("StatelessBus")

func notify_health(h: int, m: int) -> void:
    player_health_changed.emit(h, m)

## EXPERT NOTE:
## NEVER store state (e.g. current_health) in the Signal Bus.
## The bus is a 'Post Office' - it delivers messages (Signals),
## it does not store packages (State).
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — post-office bus, no stored packages
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — health_changed listeners without bus state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — HUD binds to bus signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
