# quest_manager_singleton.gd
# Centralized quest state and event handling
extends Node

# EXPERT NOTE: The QuestManager should be an Autoload to track
# progress across scene changes.

signal quest_accepted(quest: Quest)
signal quest_objective_updated(quest: Quest)
signal quest_completed(quest: Quest)

var active_quests: Dictionary = {} # StringName -> Quest
var _completion_callables: Dictionary = {} # StringName -> Callable

func accept_quest(quest: Quest) -> void:
	if quest == null or quest.id == &"":
		return
	if active_quests.has(quest.id):
		return
	quest.status = Quest.Status.ACTIVE
	active_quests[quest.id] = quest
	var cb := _on_quest_resource_completed.bind(quest.id)
	if quest.has_signal("completed"):
		quest.completed.connect(cb)
		_completion_callables[quest.id] = cb
	quest_accepted.emit(quest)

func update_objective(quest_id: StringName, amount: int = 1) -> void:
	if not active_quests.has(quest_id):
		return
	var q: Quest = active_quests[quest_id]
	q.current_count += amount
	quest_objective_updated.emit(q)
	if q.current_count >= q.objective_count:
		_complete_quest(q)

func _on_quest_resource_completed(quest_id: StringName) -> void:
	if active_quests.has(quest_id):
		_complete_quest(active_quests[quest_id])

func _complete_quest(quest: Quest) -> void:
	quest.status = Quest.Status.COMPLETED
	_disconnect_completion(quest.id)
	active_quests.erase(quest.id)
	quest_completed.emit(quest)
	if quest.next_quest:
		accept_quest(quest.next_quest)

func _disconnect_completion(quest_id: StringName) -> void:
	if not _completion_callables.has(quest_id):
		return
	var q: Quest = active_quests.get(quest_id)
	var cb: Callable = _completion_callables[quest_id]
	if q != null and q.has_signal("completed") and q.completed.is_connected(cb):
		q.completed.disconnect(cb)
	_completion_callables.erase(quest_id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/classes/class_stringname.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — QuestManager Autoload boot order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — quest_accepted / objective_updated fan-out
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
