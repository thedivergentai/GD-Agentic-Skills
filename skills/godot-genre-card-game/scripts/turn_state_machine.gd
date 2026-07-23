# turn_state_machine.gd
# Handling rigid turn phases via match patterns
extends Node

# EXPERT NOTE: match statements are the first-class way 
# to handle discrete turn-based game states.

enum Phase { DRAW, MAIN, COMBAT, END }
var current_phase: Phase = Phase.DRAW

func advance_phase():
	match current_phase:
		Phase.DRAW: current_phase = Phase.MAIN
		Phase.MAIN: current_phase = Phase.COMBAT
		Phase.COMBAT: current_phase = Phase.END
		Phase.END: current_phase = Phase.DRAW
	
	print("New Phase: ", Phase.keys()[current_phase])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — shared Draw/Main/Combat/End phase ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — escalate when phases need nested FSMs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — phase_changed events for UI locks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
