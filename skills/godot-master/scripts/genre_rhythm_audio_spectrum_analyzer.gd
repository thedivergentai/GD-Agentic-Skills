# audio_spectrum_analyzer.gd
extends Node
class_name AudioSpectrumAnalyzer

# FFT-Based Visual Reactive Data
# Uses Godot's optimized spectrum analyzer effect for visuals.

var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
    # Pattern: Get the instance from an existing Bus effect.
    spectrum_analyzer = AudioServer.get_bus_effect_instance(0, 0) # Master bus, index 0

func get_magnitude(from_hz: float, to_hz: float) -> float:
    if spectrum_analyzer:
        var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(from_hz, to_hz)
        return magnitude.length()
    return 0.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audioeffectspectrumanalyzer.html
# - https://docs.godotengine.org/en/stable/classes/class_audioeffectspectrumanalyzerinstance.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_effects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — bus effect instance setup
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — drive uniforms from magnitude bands
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — bass-reactive hit flourishes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
