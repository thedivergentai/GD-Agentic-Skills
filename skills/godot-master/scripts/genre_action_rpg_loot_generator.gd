extends Node
class_name LootGenerator

## Weighted rarity + affix rolls. Offload massive late-game rolls via WorkerThreadPool when tables grow.

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const RARITY_WEIGHTS := {
	Rarity.COMMON: 60,
	Rarity.UNCOMMON: 25,
	Rarity.RARE: 10,
	Rarity.EPIC: 4,
	Rarity.LEGENDARY: 1,
}

const RARITY_AFFIX_COUNT := {
	Rarity.COMMON: 0,
	Rarity.UNCOMMON: 1,
	Rarity.RARE: 2,
	Rarity.EPIC: 3,
	Rarity.LEGENDARY: 4,
}

@export var affix_pool: Array[Resource] = []
@export var base_items: Array[Resource] = []


func roll_rarity(magic_find: float = 0.0) -> int:
	var weights := RARITY_WEIGHTS.duplicate()
	weights[Rarity.RARE] = int(weights[Rarity.RARE] * (1.0 + magic_find / 100.0))
	weights[Rarity.EPIC] = int(weights[Rarity.EPIC] * (1.0 + magic_find / 100.0))
	weights[Rarity.LEGENDARY] = int(weights[Rarity.LEGENDARY] * (1.0 + magic_find / 100.0))
	var total := 0.0
	for w: int in weights.values():
		total += w
	var roll := randf() * total
	for rarity: int in weights.keys():
		roll -= weights[rarity]
		if roll <= 0.0:
			return rarity
	return Rarity.COMMON


func generate_affix_roll(affix: Resource, item_level: int) -> Dictionary:
	var min_roll: float = affix.get("min_value")
	var max_roll: float = affix.get("max_value")
	var scale := 1.0 + item_level * 0.1
	return {
		"affix": affix,
		"value": randf_range(min_roll * scale, max_roll * scale),
	}
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — Item resources and affix application
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — drop tables and sinks
# ---
