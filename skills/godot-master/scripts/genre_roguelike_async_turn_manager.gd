extends Node
class_name AsyncTurnManager

## Expert Turn Manager (Godot 4.7).
## Asynchronous loop using 'await' to sync actions and animations.

var entities: Array[Node] = []

func run_turn_loop() -> void:
	while true:
		for entity in entities:
			if not is_instance_valid(entity): continue
			
			# Start entity turn
			entity.begin_turn()
			
			# Expert Pattern: Halt loop until entity emits 'finished'
			# This ensures animations (Tweens) complete before the next turn.
			await entity.turn_finished
			
			if _check_victory(): return

## [SKILL NOTICE]: Use 'await' inside the turn loop to cleanly handle 
## asynchronous actions like movement Tweens and attack animations.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — await turn loops vs signal-driven schedulers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — sync attack/move animations inside turns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
