# cooldown_coroutine.gd
# Lightweight skill cooldowns without Node overhead
extends Node

# EXPERT NOTE: Timers as Nodes are heavy. Coroutines (await) 
# are lightweight and ephemeral.

var can_cast: bool = true

func fire_skill():
	if not can_cast: return
	
	_execute_logic()
	_start_cooldown(2.5)

func _start_cooldown(duration: float):
	can_cast = false
	await get_tree().create_timer(duration).timeout
	can_cast = true

func _execute_logic(): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — await create_timer cooldowns
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html — cast gating vs tick timing
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — skill cooldown patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — uptime vs cooldown balance
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
