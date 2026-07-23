extends Node
class_name FocusPromptIconSwapper

## Swap controller/keyboard prompt icons and drive a focus highlight panel.
## Wire TextureRects / Buttons that show "A / Cross / Enter" glyphs.

@export var highlight_panel: Control
@export var xbox_icon_dir: String = "res://ui/icons/xbox/"
@export var playstation_icon_dir: String = "res://ui/icons/ps/"
@export var keyboard_icon_dir: String = "res://ui/icons/keyboard/"
@export var prompt_textures: Dictionary = {}  # StringName action -> TextureRect

var _active_bank: String = ""

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_refresh_bank_from_devices()

func _on_joy_connection_changed(_device: int, _connected: bool) -> void:
	_refresh_bank_from_devices()

func _refresh_bank_from_devices() -> void:
	var bank := keyboard_icon_dir
	for device in Input.get_connected_joypads():
		var joy_name := Input.get_joy_name(device).to_lower()
		if "xbox" in joy_name:
			bank = xbox_icon_dir
			break
		if "playstation" in joy_name or "ps" in joy_name or "dualsense" in joy_name:
			bank = playstation_icon_dir
			break
	if bank != _active_bank:
		_active_bank = bank
		_apply_prompt_bank(bank)

func _apply_prompt_bank(dir: String) -> void:
	for action in prompt_textures:
		var tr: TextureRect = prompt_textures[action]
		if tr == null:
			continue
		var path := dir.path_join(str(action) + ".png")
		if ResourceLoader.exists(path):
			tr.texture = load(path)

func move_highlight_to(control: Control, duration: float = 0.12) -> void:
	if highlight_panel == null or control == null:
		return
	var tween := create_tween()
	tween.tween_property(highlight_panel, "global_position", control.get_global_rect().position, duration)
	tween.parallel().tween_property(highlight_panel, "size", control.get_global_rect().size, duration)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — joypad detection and focus navigation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — theme swap + accessibility chrome
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md
# =============================================================================
