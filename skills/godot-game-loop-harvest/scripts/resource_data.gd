# resource_data.gd
# [GDSKILLS] godot-game-loop-harvest
# EXPORT_REFERENCE: resource_data.gd

extends Resource
class_name HarvestResourceData

@export_group("Stats")
## Human-readable name (e.g., "Iron Ore").
@export var display_name: String = "Resource"
## Number of hits required to harvest.
@export var health: int = 3
## Minimum/Maximum yield per harvest.
@export var yield_range: Vector2i = Vector2i(1, 3)

@export_group("Interaction")
## Required tool type (must match HarvestToolData.ToolType).
@export var required_tool_type: HarvestToolData.ToolType = HarvestToolData.ToolType.ANY
## The minimum tool tier required to harvest this (e.g., 0 for basic, 1 for advanced).
@export var required_tier: int = 0
## The visual scene to instance (for items or effects).
@export var item_scene: PackedScene

@export_group("Respawn")
## Time in seconds before the node regrows.
@export var respawn_time: float = 60.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — HarvestResourceData as designer .tres
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — duplicate templates before runtime mutation
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html — @export_group stats/interaction/respawn
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html — optional item_scene drop instance
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource composition for yield/tool gates
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — yield_range feeds economy sources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md
# =============================================================================
