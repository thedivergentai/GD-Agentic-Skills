# collision_layer_matrix_manager.gd
# Advanced collision layer/mask management logic
extends Node

# EXPERT NOTE: Use Bit-shifting or Enums for collision layers 
# rather than magic numbers to prevent 'Collision Matrix Hell'.

enum Layer {
	WORLD = 1,
	PLAYER = 2,
	ENEMY = 4,
	PROJECTILE = 8,
	HAZARD = 16
}

func setup_projectile(node: CollisionObject2D):
	# Projectiles should be on PROJECTILE layer (8)
	# And mask for WORLD (1) and ENEMY (4)
	node.collision_layer = Layer.PROJECTILE
	node.collision_mask = Layer.WORLD | Layer.ENEMY

func set_ignore_player(node: CollisionObject2D, ignore: bool):
	if ignore:
		node.collision_mask &= ~Layer.PLAYER # Bitwise NOT and AND to remove
	else:
		node.collision_mask |= Layer.PLAYER # Bitwise OR to add

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_collisionobject2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — named layers before runtime bit math
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — world/tile layers must match body masks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
