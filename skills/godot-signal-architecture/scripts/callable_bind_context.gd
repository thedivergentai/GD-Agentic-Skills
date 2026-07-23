# callable_bind_context.gd
# Passing extra static data to signal callbacks
extends Node

func _ready():
	# Signal emits: (hit_by, level)
	# We bind: (weapon, damage)
	# Resulting callback receives: (hit_by, level, weapon, damage)
	$Player.hit.connect(_on_hit.bind("Legendary Sword", 50))

func _on_hit(hit_by: String, level: int, weapon: String, damage: int):
	print("Hit by %s (Lvl %d) with %s for %d" % [hit_by, level, weapon, damage])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Callable.bind argument order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — bind weapon/damage context on hit signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
