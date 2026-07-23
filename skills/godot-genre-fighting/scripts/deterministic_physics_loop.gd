# deterministic_physics_loop.gd
# Locking gameplay logic to fixed timesteps
extends CharacterBody2D

# EXPERT NOTE: NEVER use _process() for fighting logic. 
# Determinism requires fixed _physics_process() execution.

func _physics_process(delta):
	_apply_fighter_logic(delta)
	move_and_slide()

func _apply_fighter_logic(_d):
	# Input polling and state transitions happen here
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — fixed tick configuration
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — teleport + reset_physics_interpolation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
