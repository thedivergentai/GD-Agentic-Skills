class_name CompoundBodySync
extends Node2D
## Multiple shapes on one PhysicsServer2D body RID (shield + torso, vehicle hulls).

var _body: RID
var _shapes: Array[RID] = []

func _ready() -> void:
	_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_STATIC)
	PhysicsServer2D.body_set_space(_body, get_world_2d().space)

	var circle := PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(circle, 20.0)
	PhysicsServer2D.body_add_shape(_body, circle, Transform2D.IDENTITY)
	_shapes.append(circle)

	var box := PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(box, Vector2(10, 50))
	PhysicsServer2D.body_add_shape(
		_body, box, Transform2D.IDENTITY.translated(Vector2(30, 0))
	)
	_shapes.append(box)

func _exit_tree() -> void:
	if _body.is_valid():
		PhysicsServer2D.free_rid(_body)
	for shape in _shapes:
		if shape.is_valid():
			PhysicsServer2D.free_rid(shape)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsserver2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — compound RID parallels in 3D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
