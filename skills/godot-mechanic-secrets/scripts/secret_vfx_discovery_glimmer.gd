class_name SecretDiscoveryGlimmer
extends Node3D

## Expert Discovery 'Glimmer' VFX.
## A subtle visual cue for hidden objects that only appears occasionally.

@export var glimmer_light: OmniLight3D
@export var glimmer_frequency: float = 10.0 # Seconds between glimmers

func _ready() -> void:
	_glimmer_loop()

func _glimmer_loop() -> void:
	while true:
		await get_tree().create_timer(glimmer_frequency + randf_range(-2, 2)).timeout
		var tween = create_tween()
		tween.tween_property(glimmer_light, "light_energy", 2.0, 0.5)
		tween.tween_property(glimmer_light, "light_energy", 0.0, 0.5)

## Tip: Use 'Random Offset' in frequencies to make glimmers feel more organic and less mechanical.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — light_energy glimmer tween loop
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — optional sparkle accompany
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
