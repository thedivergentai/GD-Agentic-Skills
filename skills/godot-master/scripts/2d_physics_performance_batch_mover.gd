# performance_batch_mover.gd
# Moving 100+ StaticBody2Ds without performance tanking
extends Node2D

# PROBLEM: Moving many StaticBody2Ds per frame is expensive.
# SOLUTION: Disable collision while moving or use AnimatableBody2D 
# which is optimized for code-driven movement.

@onready var platforms: Array = get_children().filter(func(c): return c is AnimatableBody2D)

func _physics_process(delta: float) -> void:
	for p in platforms:
		# AnimatableBody2D correctly calculates velocity for riders
		p.position.x += 100 * delta * sin(Time.get_ticks_msec() / 1000.0)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html
# - https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — many moving platforms without tanking physics
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — rider-aware moving platforms
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
