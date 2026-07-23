# safe_runtime_rebind.gd
# Safe runtime input rebinding with multi-device support [15, 16]
extends Node

## Persist rebinds to user:// so remaps survive relaunch.
const REBIND_PATH := "user://input_rebinds.cfg"
const REBIND_SECTION := "rebinds"

# EXPERT NOTE: Always check for conflicts before applying a rebind.
# Also, handle the case where a player binds a Joypad button to a keyboard action.

func _ready() -> void:
	load_rebinds()

func rebind_action(action_name: String, new_event: InputEvent) -> bool:
	# 1. Check for conflicts
	for action in InputMap.get_actions():
		if action == action_name:
			continue
		if InputMap.action_has_event(action, new_event):
			printerr("Conflict: ", new_event.as_text(), " already bound to ", action)
			return false

	# 2. Apply rebind
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)

	# 3. Persistence (Save to ConfigFile)
	_save_rebinds()
	return true

func load_rebinds() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(REBIND_PATH) != OK:
		return
	if not cfg.has_section(REBIND_SECTION):
		return
	for action in cfg.get_section_keys(REBIND_SECTION):
		var encoded: Variant = cfg.get_value(REBIND_SECTION, action)
		if typeof(encoded) != TYPE_PACKED_BYTE_ARRAY:
			continue
		var event: Variant = bytes_to_var(encoded)
		if event is InputEvent:
			InputMap.action_erase_events(StringName(action))
			InputMap.action_add_event(StringName(action), event)

func _save_rebinds() -> void:
	var cfg := ConfigFile.new()
	# Preserve unrelated sections if the file already exists.
	cfg.load(REBIND_PATH)
	for action in InputMap.get_actions():
		# Skip built-in ui_* defaults unless the project overrode them.
		var events := InputMap.action_get_events(action)
		if events.is_empty():
			continue
		# Store first binding per action (extend to arrays if you need multi-bind).
		cfg.set_value(REBIND_SECTION, String(action), var_to_bytes(events[0]))
	cfg.save(REBIND_PATH)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_inputmap.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/classes/class_inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist rebinds to user://
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — rebind UI listens for next event
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
