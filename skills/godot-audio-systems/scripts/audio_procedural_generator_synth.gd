class_name AudioProceduralGeneratorSynth
extends Node

## Expert real-time procedural audio synthesizer.
## Pushes raw frames to an 'AudioStreamGeneratorPlayback'.

var playback: AudioStreamGeneratorPlayback
var sample_rate: float

func _ready() -> void:
	var generator = $AudioStreamPlayer.stream as AudioStreamGenerator
	sample_rate = generator.mix_rate
	playback = $AudioStreamPlayer.get_stream_playback()

func fill_buffer(frequency: float = 440.0) -> void:
	var phase = 0.0
	var increment = frequency / sample_rate
	var frames_to_fill = playback.get_frames_available()
	
	for i in range(frames_to_fill):
		var sample = sin(phase * TAU)
		playback.push_frame(Vector2(sample, sample))
		phase = fmod(phase + increment, 1.0)

## Rule: Always check 'get_frames_available()' before pushing to avoid buffer underrun.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamgenerator.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamgeneratorplayback.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — fill_buffer cost vs mix latency
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md — procedural clicks/metronomes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — tight _process fill loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
