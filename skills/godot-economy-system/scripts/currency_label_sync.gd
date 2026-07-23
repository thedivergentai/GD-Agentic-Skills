# currency_label_sync.gd
# Reactive UI for balance display
extends Label

@export var currency_id: String = "gold"

func _ready():
	WalletManager.balance_changed.connect(_on_balance_changed)
	text = str(WalletManager.balances.get(currency_id, 0))

func _on_balance_changed(id: String, amount: int):
	if id == currency_id:
		text = str(amount)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — HUD label placement
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — subscribe to balance_changed only
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
