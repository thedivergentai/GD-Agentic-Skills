# node_path_safe_retrieval.gd
# Robust node path handling to prevent 'Null Instance' errors
extends Node

# EXPERT NOTE: Avoid hardcoded Nodepaths like get_node("../../Player") 
# as they break if the hierarchy changes. Use @onready and Unique Names.

@onready var player = %Player # Using Scene Unique Name (%)

func _ready() -> void:
	if not player:
		push_error("Critical error: Player not found in scene!")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html
# - https://docs.godotengine.org/en/stable/classes/class_nodepath.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — @onready + typed node exports for safe refs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — prefer exports over deep relative NodePaths
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
