# decoupled_economy_signal_bus.gd
extends Node

# Decoupled Economy Signal Bus
# Ensures the internal simulation is completely independent from the visual UI layer.
signal currency_updated(total: float, delta: float)

var _total_currency: float = 0.0

func add_currency(amount: float) -> void:
    _total_currency += amount
    
    # Emit signal for any UI listeners to update themselves only when necessary.
    currency_updated.emit(_total_currency, amount)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — currency_updated signal discipline
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — bus ownership across scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
