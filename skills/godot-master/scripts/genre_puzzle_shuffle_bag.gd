# shuffle_bag.gd
extends Node
class_name ShuffleBag

# Shuffle Bag for Procedural Generation
# Generates non-repeating random values (e.g., Match-3 block types).

var _items: Array[Variant] = []
var _full_items: Array[Variant] = []

func initialize(items_to_shuffle: Array) -> void:
    _full_items = items_to_shuffle.duplicate()
    _refill_and_shuffle()

func _refill_and_shuffle() -> void:
    _items = _full_items.duplicate()
    _items.shuffle()

func get_next() -> Variant:
    if _items.is_empty():
        # Pattern: Reinitialize when empty to guarantee fair distribution.
        _refill_and_shuffle()
    return _items.pop_front()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — stress fair bag distributions vs pure RNG streaks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — feed bag draws into generated boards
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
