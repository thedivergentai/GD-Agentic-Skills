# harvest_tool_data.gd
# [GDSKILLS] godot-game-loop-harvest
# EXPORT_REFERENCE: harvest_tool_data.gd

extends Resource
class_name HarvestToolData

enum ToolType { ANY, AXE, PICKAXE, SHOVEL, SCYTHE }

@export_group("Stats")
## Human-readable name (e.g., "Steel Axe").
@export var display_name: String = "Tool"
## Tool family for harvest gates (enum — not free-form strings).
@export var tool_type: ToolType = ToolType.ANY
## Damage dealt per hit to the resource.
@export var damage: int = 1
## Tier of the tool (0 = basic, 1 = advanced).
@export var tier: int = 0

signal durability_changed(current: int, max_durability: int)
signal tool_broken

@export_group("Durability")
@export var max_durability: int = 100
var durability: int = 100

func apply_wear(amount: int = 1) -> void:
	durability = maxi(durability - amount, 0)
	durability_changed.emit(durability, max_durability)
	if durability == 0:
		tool_broken.emit()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — tool type/tier/damage as Resource
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — serialize/swap tools without node state
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html — Inspector-tuned damage and tier
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — tool Resources beside harvest Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — equippable tools as inventory items
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md
# =============================================================================
