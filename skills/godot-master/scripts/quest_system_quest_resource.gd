# quest_resource.gd
# Data-driven quest definition
class_name Quest extends Resource

# EXPERT NOTE: Defining quests as Resources allows for
# branching logic and complex reward structures in the Inspector.

enum Status { AVAILABLE, ACTIVE, COMPLETED, FAILED }

signal completed

@export var id: StringName = &""
@export var title: String = ""
@export_multiline var description: String = ""
@export var objective_count: int = 1
@export var rewards: Array[InventoryItem] = []
@export var next_quest: Quest # For simple linear chains

var status: Status = Status.AVAILABLE
var current_count: int = 0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/classes/class_stringname.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Inspector-authored quest Resources and nested objectives
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — reward Array typed against inventory items
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
