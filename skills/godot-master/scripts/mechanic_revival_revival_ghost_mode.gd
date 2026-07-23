class_name RevivalGhostMode
extends Node

## Expert Ghost/Spirit Mode logic.
## Swaps collision masks and modulates visuals upon death.

func enter_ghost_mode(player: CharacterBody3D) -> void:
	# Disable 'standard' collision, enable 'ghost' layer (e.g. Layer 5)
	player.collision_layer = 1 << 4 
	player.collision_mask = 1 << 0 | 1 << 4 # Walls + Ghosts only
	
	player.modulate.a = 0.5 # Transparency
	# Trigger 'Spirit World' shader here...

## Rule: Ghost mode requires a 'Revival Shrine' interaction to return to the living state.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html — collision_layer / mask spirit swap
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html — ghost body still moves with filters
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — spirit-realm visual swap with layer change
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — prevent hazard hits while ghosted
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
