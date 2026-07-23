# procedural_track_modifier.gd
# Modifying specific animation tracks via code at runtime [5]
extends AnimationPlayer

func tweak_jump_height(new_height: float) -> void:
	var anim: Animation = get_animation("jump")
	
	# Find the track index for the Y position
	var track_idx = anim.find_track(".:position:y", Animation.TYPE_VALUE)
	
	if track_idx != -1:
		# Update the peak keyframe (usually in the middle)
		# Expert: Use track_set_key_value instead of deleting/re-adding
		var key_idx = 1 # Assume index 1 is the peak
		anim.track_set_key_value(track_idx, key_idx, -new_height)
		
		# If you need immediate visual feedback while paused:
		if not is_playing():
			seek(current_animation_position, true)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animation.html
# - https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — safe runtime track_set_key_value edits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — jump-height retarget without new clips
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
