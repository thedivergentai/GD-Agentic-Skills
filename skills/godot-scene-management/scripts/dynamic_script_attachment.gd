# dynamic_script_attachment.gd
# Attaching scripts to nodes at runtime [Modding System]
extends Node

func apply_script_to_node(node: Node, script_path: String):
	var script = load(script_path)
	if script is Script:
		node.set_script(script)
		# Re-run _ready if needed, or call init
		node.notification(NOTIFICATION_READY)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — mod/DLC packs supplying runtime scripts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — script paths as Resource metadata for mods
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
