# physics_server_3d_bullets.gd
# High-performance 3D physics using PhysicsServer3D directly [17]
extends Node3D

# EXPERT NOTE: PhysicsServer3D is essential for 3D projectiles 
# to avoid the overhead of thousands of RigidBody3D nodes.

var _bodies: Array[RID] = []
var _shape: RID

func _ready() -> void:
	_shape = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(_shape, 0.5)
	
	for i in range(50):
		var body = PhysicsServer3D.body_create()
		PhysicsServer3D.body_set_mode(body, PhysicsServer3D.BODY_MODE_RIGID)
		PhysicsServer3D.body_add_shape(body, _shape)
		PhysicsServer3D.body_set_space(body, get_world_3d().space)
		PhysicsServer3D.body_set_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM, Transform3D(Basis(), Vector3(randf()*10, 10, randf()*10)))
		_bodies.append(body)

func _exit_tree() -> void:
	for body in _bodies:
		PhysicsServer3D.free_rid(body)
	PhysicsServer3D.free_rid(_shape)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — RID swarm pooling vs SceneTree RigidBody3D cost
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — projectile layer/mask consumers of server bodies
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
