# quest_ui_tracker.gd
# Dynamic list of active objectives
extends VBoxContainer

# EXPERT NOTE: The UI should be purely reactive, 
# populating itself based on QuestManager signals.

func _ready():
	QuestManager.quest_accepted.connect(_add_quest_track)
	QuestManager.quest_completed.connect(_remove_quest_track)
	QuestManager.quest_objective_updated.connect(_update_quest_track)

func _add_quest_track(quest: Quest):
	var label = Label.new()
	label.name = quest.id
	add_child(label)
	_update_quest_track(quest)

func _update_quest_track(quest: Quest):
	var label = get_node_or_null(quest.id)
	if label:
		label.text = "%s: %d/%d" % [quest.title, quest.current_count, quest.objective_count]

func _remove_quest_track(quest: Quest):
	var label = get_node_or_null(quest.id)
	if label:
		label.queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# - https://docs.godotengine.org/en/stable/classes/class_vboxcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — reactive VBox rebuild from manager signals only
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — connect accepted/updated/completed in _ready
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
