class_name LootTable extends Resource

## Data-driven weighted loot table using Godot 4 native optimization.
## Avoids slow GDScript loops for probability calculation.

@export var items: Array[Resource] = []
@export var weights: PackedFloat32Array = PackedFloat32Array()

## Uses native rand_weighted for O(1) or O(log N) speed depending on size.
func roll_item(rng: RandomNumberGenerator) -> Resource:
	if items.is_empty() or weights.size() != items.size():
		push_error("LootTable: Weights size mismatch or empty items.")
		return null
		
	var rolled_idx := rng.rand_weighted(weights)
	return items[rolled_idx]

func add_entry(item: Resource, weight: float) -> void:
	items.append(item)
	weights.append(weight)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — drop Resources into run inventories
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — dead-item and pity-timer validation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
