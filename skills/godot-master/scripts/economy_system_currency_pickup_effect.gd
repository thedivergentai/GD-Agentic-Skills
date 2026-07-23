# currency_pickup_effect.gd
# Visual feedback for financial gains
extends GPUParticles2D

# EXPERT NOTE: Trigger visual effects via balance signals 
# to ensure the world "feels" the impact of economic changes.

func _ready():
	WalletManager.balance_changed.connect(_on_balance_changed)

func _on_balance_changed(id: String, _amount: int):
	if id == "gold":
		restart()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles2d.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — VFX reacts to balance_changed
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — pickup burst tuning
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
