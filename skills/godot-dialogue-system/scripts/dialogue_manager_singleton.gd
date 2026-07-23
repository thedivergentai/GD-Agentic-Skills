# dialogue_manager_singleton.gd
# Managing conversation state and signals
extends Node

# EXPERT NOTE: The DialogueManager handles the traversal 
# of the DialogueResource tree.

signal line_started(node: DialogueNode)
signal dialogue_finished

var current_dialogue: DialogueResource
var current_node: DialogueNode

func start_dialogue(res: DialogueResource):
	current_dialogue = res
	_show_node(res.start_node)

func select_option(index: int):
	var option = current_node.options[index]
	_show_node(option.next_node_id)

func _show_node(node_id: String):
	if node_id == "end" or not current_dialogue.nodes.has(node_id):
		dialogue_finished.emit()
		return
		
	current_node = current_dialogue.nodes[node_id]
	line_started.emit(current_node)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — Autoload ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — dialogue state signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
