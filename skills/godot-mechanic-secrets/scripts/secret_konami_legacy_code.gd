class_name SecretKonamiLegacy
extends SecretSequenceComboMatcher

## Classic Konami Code Specialization.
## Example of extending the Sequence Matcher for the most famous cheat.

func _ready() -> void:
	sequences = {
		"Konami": ["ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right", "ui_accept"]
	}
	combo_achieved.connect(_on_konami)

func _on_konami(combo_name: String) -> void:
	if combo_name == "Konami":
		SecretMetaPersistence.unlock_meta_secret("konami_legacy_achieved")
		# Give 30 lives or enable debug mode...

## Rule: The Konami code is a 'Gamer Rite of Passage'—always include it in retro-styled projects.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — ui_* action bindings for pad/keyboard parity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — meta unlock persistence after Konami
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
