extends CharacterBody2D
class_name RootMotionController2D

## Apply AnimationTree root motion as velocity — feet stay locked to authored clips.

@export var animation_tree: AnimationTree


func _physics_process(delta: float) -> void:
	if animation_tree == null:
		move_and_slide()
		return
	var root_motion: Vector3 = animation_tree.get_root_motion_position()
	var motion_2d := Vector2(root_motion.x, root_motion.z)
	velocity = motion_2d / delta if delta > 0.0 else Vector2.ZERO
	move_and_slide()
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html — get_root_motion_position API
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — clip-driven locomotion
# ---
