# skills/audio-systems/code/audio_manager.gd
extends Node

## AudioManager Singleton Expert Pattern
## Centralized system for sound pooling and bus management.

const MAX_POOL_SIZE = 32
var _pool: Array[AudioStreamPlayer] = []

func _ready() -> void:
    # 1. Initialize Sound Pool
    for i in range(MAX_POOL_SIZE):
        var player = AudioStreamPlayer.new()
        add_child(player)
        _pool.append(player)

func play_sfx(stream: AudioStream, bus: String = "SFX") -> void:
    # 2. Find Available Player
    var player = _find_available_player()
    if player:
        player.stream = stream
        player.bus = bus
        player.play()

func crossfade_music(to_stream: AudioStream, duration: float = 1.0) -> void:
    # 3. Dynamic Music Crossfading logic
    pass

func _find_available_player() -> AudioStreamPlayer:
    for player in _pool:
        if not player.playing:
            return player
    return null

## NEVER LIST:
## - NEVER play positional 3D audio on a node that dies.
## - Use 'AudioStreamPlayer3D' but parent it to the world root, 
##   setting its 'global_position' manually.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — singleton AudioManager pattern
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — music crossfade helpers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — keep manager across scene changes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
