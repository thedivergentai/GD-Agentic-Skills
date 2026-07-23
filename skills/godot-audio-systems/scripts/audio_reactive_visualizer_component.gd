class_name AudioReactiveVisualizer
extends Node

## Expert spectrum-driven visualizer.
## Extracts magnitude from frequency ranges (Bass/Mid/High).

var spectrum: AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(0, 0) # Index 0 of Master Bus

func get_bass_magnitude() -> float:
	var mag = spectrum.get_magnitude_for_frequency_range(20, 150)
	return mag.length()

## Tip: Use 'magnitude' to drive shader uniforms or light energy for audio-reactivity.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audioeffectspectrumanalyzer.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_effects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — drive uniforms from magnitude bands
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — pulse emission from bass energy
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — light energy from spectrum peaks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
