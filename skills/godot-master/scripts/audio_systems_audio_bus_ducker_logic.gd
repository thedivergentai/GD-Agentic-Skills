class_name AudioBusDuckerLogic
extends Node

## Expert 'Sidechain' style Bus Ducking.
## Lowers music volume when a 'Hero' sound (SFX) is triggered.

@export var target_bus: String = "Music"
@export var trigger_bus: String = "Dialog"

func duck_bus(amount_db: float = -15.0, duration: float = 0.5) -> void:
	var bus_idx = AudioServer.get_bus_index(target_bus)
	var original_db = AudioServer.get_bus_volume_db(bus_idx)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(v): AudioServer.set_bus_volume_db(bus_idx, v), original_db, amount_db, 0.1)
	tween.tween_interval(duration)
	tween.tween_method(func(v): AudioServer.set_bus_volume_db(bus_idx, v), amount_db, original_db, 0.5)

## Rule: Ducking is essential for clarity in narrative-heavy or loud combat games.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# - https://docs.godotengine.org/en/stable/classes/class_audioeffectcompressor.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — Dialog bus as duck trigger
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — attack/release volume ramps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — keep Music bus user volume as duck baseline
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
