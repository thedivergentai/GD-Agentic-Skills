class_name AudioFootstepSurfaceSelector
extends RayCast3D

## Expert multi-surface footstep selector.
## Detects floor type via Physics and picks the correct sound bank.

var surface_sounds: Dictionary = {
	"Stone": preload("res://audio/steps_stone.tres"),
	"Wood": preload("res://audio/steps_wood.tres")
}

func get_step_stream() -> AudioStream:
	if is_colliding():
		var collider = get_collider()
		# Expert: Use Groups or Metadata to identify surface type
		for group in surface_sounds.keys():
			if collider.is_in_group(group):
				return surface_sounds[group].get_random()
	return null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamrandomizer.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — floor RayCast3D surface hits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — step cadence from movement state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — groups/metadata on floor colliders
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
