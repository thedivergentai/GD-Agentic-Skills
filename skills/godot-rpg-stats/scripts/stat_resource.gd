# skills/rpg-stats/scripts/stat_resource.gd
extends Resource

## Stat Resource Expert Pattern
## Modular stat system with modifier stacks, dirty flags, and derived stat support.

class_name StatResource

signal value_changed(new_value: float, old_value: float)
signal modifier_added(modifier: StatModifier)
signal modifier_removed(modifier: StatModifier)

@export var base_value: float = 10.0:
	set(v):
		var old = base_value
		base_value = v
		_dirty = true
		value_changed.emit(value, get_value_from_base(old))

var _modifiers: Array[StatModifier] = []
var _cached_value: float = 0.0
var _dirty: bool = true

var value: float:
	get:
		if _dirty:
			_recalculate()
		return _cached_value

func add_modifier(mod: StatModifier) -> void:
	_modifiers.append(mod)
	mod.changed.connect(_on_modifier_changed)
	_dirty = true
	modifier_added.emit(mod)
	value_changed.emit(value, _cached_value) # Value updates lazily, but signal needs current

func remove_modifier(mod: StatModifier) -> void:
	if mod in _modifiers:
		_modifiers.erase(mod)
		mod.changed.disconnect(_on_modifier_changed)
		_dirty = true
		modifier_removed.emit(mod)
		value_changed.emit(value, _cached_value)

func get_value_from_base(base: float) -> float:
	# Recalculate hypothetical value
	var v = base
	for mod in _modifiers:
		if mod.type == StatModifier.Type.ADD:
			v += mod.value
	for mod in _modifiers:
		if mod.type == StatModifier.Type.MULTIPLY:
			v *= mod.value
	return v

func _recalculate() -> void:
	_cached_value = get_value_from_base(base_value)
	_dirty = false

func _on_modifier_changed() -> void:
	_dirty = true
	value_changed.emit(value, _cached_value)

# Inner class for easy portability
class StatModifier extends Resource:
	enum Type { ADD, MULTIPLY }
	signal changed
	
	@export var type: Type = Type.ADD:
		set(v): type = v; changed.emit()
	@export var value: float = 0.0:
		set(v): value = v; changed.emit()
	@export var source: Variant # Optional reference to source weapon/buff

## EXPERT USAGE:
## @export var strength: StatResource
## strength.add_modifier(sword_mod)
## print(strength.value)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — dirty-flag / cached derived values
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — value_changed after modifier stack edits
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
