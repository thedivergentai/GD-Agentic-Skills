# wall_slide_jump_refined.gd
# Responsive wall sliding and wall jumping mechanics
extends CharacterBody2D

@export var wall_slide_speed := 100.0
@export var wall_jump_pushback := 300.0

func _physics_process(delta: float) -> void:
	var on_wall = is_on_wall_only()
	
	if on_wall:
		# Limit fall speed while on wall
		velocity.y = min(velocity.y, wall_slide_speed)
		
		if Input.is_action_just_pressed("jump"):
			# Push away from wall and up
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * wall_jump_pushback
			velocity.y = -400
			
	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# - https://docs.godotengine.org/en/stable/classes/class_kinematiccollision2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md — wall-jump ability gating
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — wall-slide state transitions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
