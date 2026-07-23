class_name RoguelikeRNG extends Resource

## Resource for managing seeded randomness and persistence.
## Stores the internal PCG32 state for deterministic reloads.

@export var seed_value: int = 0
var _rng := RandomNumberGenerator.new()

func initialize(new_seed: int) -> void:
	seed_value = new_seed
	_rng.seed = seed_value

func get_generator() -> RandomNumberGenerator:
	return _rng

## Replay-safe state capturing
func save_state() -> int:
	return _rng.state

func load_state(saved_state: int) -> void:
	_rng.seed = seed_value
	_rng.state = saved_state

## Utility for "fair" random using shuffle bag
func get_shuffled_bag(items: Array) -> Array:
	var bag := items.duplicate()
	bag.shuffle()
	return bag
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — persist seed/state for shareable runs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — seeded Monte Carlo of loot/win rates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
