class_name AudioOcclusionRaycast
extends Node3D

## Expert Audio Occlusion logic.
## Dynamically applies attenuation_filter_cutoff_hz when the line-of-sight is blocked.

@export var audio_player: AudioStreamPlayer3D
@export var collision_mask: int = 1

const FREQ_CLEAR := 20500.0 # Effect disabled
const FREQ_OCCLUDED := 1200.0 # Muffled

var _active_tween: Tween

func _physics_process(_delta: float) -> void:
	if not audio_player.playing: return
	
	var camera = get_viewport().get_camera_3d()
	if not camera: return
	
	# Check line of sight
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, camera.global_position, collision_mask, [audio_player.get_rid()])
	var result = space.intersect_ray(query)
	
	var target_hz = FREQ_OCCLUDED if not result.is_empty() else FREQ_CLEAR
	
	if not is_equal_approx(audio_player.attenuation_filter_cutoff_hz, target_hz):
		_fade_to_freq(target_hz)

func _fade_to_freq(target: float) -> void:
	if _active_tween: _active_tween.kill()
	_active_tween = create_tween()
	_active_tween.tween_property(audio_player, "attenuation_filter_cutoff_hz", target, 0.25).set_trans(Tween.TRANS_SINE)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_effects.html
# - https://docs.godotengine.org/en/stable/classes/class_audioeffectlowpassfilter.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — PhysicsRayQueryParameters3D masks for LOS
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — collision layers for occluders
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — smooth attenuation_filter_cutoff_hz ramps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
