# skills/genre-simulation/scripts/tycoon_economy.gd
extends Node

## Tycoon Economy Manager (Expert Pattern)
## Integer cents / discrete stock units — never float primary currency.

class_name TycoonEconomy

signal resource_changed(type: StringName, current: int, max_amount: int)
signal bankruptcy_warning

var resources: Dictionary = {
	&"money": 100000,  # $1000.00 in cents
	&"materials": 0,
	&"energy": 100
}

var caps: Dictionary = {
	&"money": 99999999,
	&"materials": 500,
	&"energy": 200
}

func modify_resource(type: StringName, amount: int) -> bool:
	if not resources.has(type):
		return false
	var current: int = resources[type]
	if type == &"money" and current + amount < 0:
		bankruptcy_warning.emit()
		return false
	var cap: int = int(caps.get(type, 99999999))
	var new_val: int = clampi(current + amount, 0, cap)
	resources[type] = new_val
	resource_changed.emit(type, new_val, cap)
	return true

func get_resource(type: StringName) -> int:
	return int(resources.get(type, 0))

func money_display() -> String:
	var cents: int = get_resource(&"money")
	return "$%.2f" % (cents / 100.0)

## EXPERT USAGE:
## Autoload or instantiate in Main Scene.
## Connect UI to resource_changed; never poll floats every frame.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — wallets/sinks composing with multi-resource stocks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — prove bankruptcy and growth bands
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-simulation/SKILL.md
# =============================================================================
