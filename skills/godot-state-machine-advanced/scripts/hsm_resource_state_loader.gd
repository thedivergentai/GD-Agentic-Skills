class_name HSMResourceStateLoader
extends Node

## Expert Data-Driven State Loader.
## Loads state configurations from .tres (Resource) files for modular AI.

@export var state_resources: Array[Resource]

func initialize_states() -> void:
	for res in state_resources:
		# Assume resource has a path to a script
		var state_node := Node.new()
		state_node.set_script(res.state_script)
		state_node.name = res.state_name
		add_child(state_node)

## Rule: Using Resources allows designers to tweak AI values without touching code.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — .tres state defs designers can tune without code
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — resource folder layout and export wiring for AI kits
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
