class_name TurnManager extends Node

## Signal-based coordinator for turn-based games.
## Decouples entity logic from global scheduling.

signal turn_started(entity: Node)
signal all_turns_completed

var _entities: Array[Node] = []
var _current_index: int = 0

func register_entity(entity: Node) -> void:
	if not _entities.has(entity):
		_entities.append(entity)
		# Expects entities to have a turn_finished signal
		if entity.has_signal(&"turn_finished"):
			entity.connect(&"turn_finished", _on_entity_turn_finished)

func start_loop() -> void:
	_current_index = 0
	_trigger_turn()

func _on_entity_turn_finished() -> void:
	_current_index += 1
	if _current_index >= _entities.size():
		_current_index = 0
		all_turns_completed.emit()
	
	# Start next turn on next frame to prevent deep recursion
	_trigger_turn.call_deferred()

func _trigger_turn() -> void:
	if _entities.is_empty(): return
	turn_started.emit(_entities[_current_index])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — signal-driven turn coordination
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — global turn Autoload without entity coupling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
