# root_motion_physics_sync.gd
# Expert Root Motion extraction for CharacterBody3D [155]
extends CharacterBody3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# 1. Fetch the delta transform from the root bone animation
	var motion_pos = anim_player.get_root_motion_position()
	var motion_rot = anim_player.get_root_motion_rotation()
	
	# 2. Transform the animation delta into world space relative to current orientation
	var v = (quaternion * motion_pos) / delta
	
	# 3. Apply horizontal velocity while preserving vertical (gravity)
	velocity.x = v.x
	velocity.z = v.z
	
	# 4. Integrate rotation (usually only Y axis for 3D characters)
	quaternion *= motion_rot
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta
		
	move_and_slide()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationmixer.html
# - https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — move_and_slide with extracted root deltas
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md — root motion under AnimationTree graphs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
