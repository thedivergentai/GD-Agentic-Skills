class_name AudioLinearVolumeInterpolator
extends Node

## Expert linear-to-db volume interpolation.
## Essential for smooth UI sliders that feel musically correct.

func set_linear_volume(bus_name: String, value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_idx, db_value)

## Rule: Volume sliders must ALWAYS use 'linear_to_db'. Constant DB change = Logarithmic feel.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — wire HSlider 0–1 to linear_to_db
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist linear bus values
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — default bus layout names
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
