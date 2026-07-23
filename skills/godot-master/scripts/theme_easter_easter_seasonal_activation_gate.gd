class_name EasterSeasonalActivationGate
extends Node

## Expert date-aware activation manager.
## Date window + player opt-out + Dev Override (check once on ready / settings change).

signal seasonal_active_changed(active: bool)

@export var easter_content_root: Node
## Inclusive month/day window (default: April 1–30).
@export var start_month: int = 4
@export var start_day: int = 1
@export var end_month: int = 4
@export var end_day: int = 30
## Force-on for QA outside the calendar window.
@export var dev_override_force_on: bool = false
## Force-off even during the window (also respects player opt-out).
@export var dev_override_force_off: bool = false
@export var settings_path: String = "user://settings.cfg"
@export var settings_section: String = "accessibility"
@export var opt_out_key: String = "disable_seasonal_themes"

var is_active: bool = false

func _ready() -> void:
	refresh_activation()

func refresh_activation() -> void:
	is_active = _compute_active()
	if easter_content_root:
		easter_content_root.visible = is_active
		easter_content_root.process_mode = (
			Node.PROCESS_MODE_INHERIT if is_active else Node.PROCESS_MODE_DISABLED
		)
	seasonal_active_changed.emit(is_active)

func _compute_active() -> bool:
	if dev_override_force_off:
		return false
	if _player_opted_out():
		return false
	if dev_override_force_on:
		return true
	return _in_date_window(Time.get_date_dict_from_system())

func _player_opted_out() -> bool:
	var cfg := ConfigFile.new()
	if cfg.load(settings_path) != OK:
		return false
	return bool(cfg.get_value(settings_section, opt_out_key, false))

func _in_date_window(date: Dictionary) -> bool:
	var m: int = int(date.month)
	var d: int = int(date.day)
	var start_key := start_month * 100 + start_day
	var end_key := end_month * 100 + end_day
	var cur_key := m * 100 + d
	if start_key <= end_key:
		return cur_key >= start_key and cur_key <= end_key
	# Wrap across year boundary (e.g. Dec 20 → Jan 10)
	return cur_key >= start_key or cur_key <= end_key

## Rule: Always provide a 'Dev Override' flag to test seasonal content off-season.
## Rule: NEVER date-check in _process — call refresh_activation() from settings UI instead.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — base Theme architecture
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — confetti/shimmer VFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md
# =============================================================================
