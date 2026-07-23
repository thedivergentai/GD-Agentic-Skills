# skills/audio-systems/scripts/audio_bus_manager.gd
extends Node

## Audio Bus Manager Expert Pattern
## Advanced audio routing, ducking, and pool management.

class_name AudioBusManager

const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"
const BUS_UI = "UI"
const BUS_VOICE = "Voice"

@export var sfx_pool_size := 32

var _sfx_pool: Array[AudioStreamPlayer] = []
var _music_players: Dictionary = {} # { "track_name": AudioStreamPlayer }

func _ready() -> void:
	_init_sfx_pool()

func _init_sfx_pool() -> void:
	for i in sfx_pool_size:
		var player := AudioStreamPlayer.new()
		player.bus = BUS_SFX
		player.finished.connect(func(): player.stop()) # Ensure cleaned up state
		add_child(player)
		_sfx_pool.append(player)

func play_sfx(stream: AudioStream, pitch_scale := 1.0, volume_db := 0.0) -> void:
	var player := _get_available_sfx_player()
	if player:
		player.stream = stream
		player.pitch_scale = pitch_scale
		player.volume_db = volume_db
		player.play()

func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_pool:
		if not player.playing:
			return player
	
	# Optional: Steal oldest voice if critical (not implemented here for simplicity)
	push_warning("SFX pool exhausted")
	return null

func play_music(stream: AudioStream, crossfade_duration := 2.0) -> void:
	# Crossfade logic would go here, utilizing a Tween to lower current track vol
	# and raise new track vol.
	
	var tween = create_tween()
	# ... (Implementation of crossfade omitted for brevity, but this is where it lives)
	pass

func duck_music_for_voice(ducking_amount := -10.0, duration := 0.5) -> void:
	var bus_idx := AudioServer.get_bus_index(BUS_MUSIC)
	var tween := create_tween()
	tween.tween_method(
		func(v): AudioServer.set_bus_volume_db(bus_idx, v),
		AudioServer.get_bus_volume_db(bus_idx),
		ducking_amount,
		duration
	)

func restore_music_volume(duration := 1.0) -> void:
	var bus_idx := AudioServer.get_bus_index(BUS_MUSIC)
	var tween := create_tween()
	tween.tween_method(
		func(v): AudioServer.set_bus_volume_db(bus_idx, v),
		AudioServer.get_bus_volume_db(bus_idx),
		0.0, # Target normal volume
		duration
	)

## EXPERT USAGE:
## AudioBusManager.play_sfx(preload("res://boom.wav"), 1.2)
## AudioBusManager.duck_music_for_voice()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/classes/class_audiobuslayout.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_effects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — author Bus Layout resource
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — central bus/pool owner
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — restore mute/volume per bus
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
