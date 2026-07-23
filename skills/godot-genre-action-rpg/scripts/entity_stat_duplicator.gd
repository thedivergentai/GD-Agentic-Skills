# entity_stat_duplicator.gd
extends Node
class_name EntityStatDuplicator

# Deep Duplication for Unique Entity State
# Ensures instanced enemies/allies have unique stat blocks, not globally shared ones.

@export var base_stats: CharacterStatsResource
var current_stats: CharacterStatsResource

func _ready() -> void:
    # Pattern: ALWAYS duplicate shared resources to prevent cross-entity state leaks.
    if base_stats:
        # Use DEEP_DUPLICATE_ALL to ensure internal dictionaries/sub-resources are unique.
        current_stats = base_stats.duplicate(true) as CharacterStatsResource
        print("Stats localized for: ", get_parent().name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — deep duplicate(true)
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — prevent cross-instance leaks
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — spawn-time localization
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — unique current_stats blocks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
