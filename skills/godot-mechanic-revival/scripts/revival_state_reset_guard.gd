class_name RevivalStateResetGuard
extends Node

## Expert Physics & State Reset Guard.
## Essential for preventing the 'Post-Respawn Jitter' or death momentum.

func clean_player_state(player: CharacterBody3D) -> void:
	player.velocity = Vector3.ZERO
	# Clear impulse buffers or state machine locks
	if player.has_node("StateMachine"):
		player.get_node("StateMachine").transition_to("Idle")

## Rule: Always zero out velocity on respawn. Failing to do so can cause 'momentum physics' crashes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html — zero velocity on respawn
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html — clear residual physics state
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — force Idle after death locks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — reset guard as child utility
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
