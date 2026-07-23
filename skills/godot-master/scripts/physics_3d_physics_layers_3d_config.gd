# physics_layers_3d_config.gd
# 3D Collision matrix architecture using bitmasks
extends Node

enum Layer {
	WORLD = 1 << 0,
	PLAYER = 1 << 1,
	ENEMY = 1 << 2,
	BULLET = 1 << 3,
	INTERACTABLE = 1 << 4
}

func apply_bullet_collision(body: CollisionObject3D):
	# Bullets are on BULLET layer
	body.collision_layer = Layer.BULLET
	# Mask for WORLD and ENEMY
	body.collision_mask = Layer.WORLD | Layer.ENEMY
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — Project Settings 3D physics layer names
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — shared layer/mask mental model across dimensions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
