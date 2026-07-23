# skills/genre-card-game/scripts/card_data.gd
extends Resource

## Card Data Resource (Expert Pattern)
## Data definition for cards. Can be created in Inspector.

class_name CardData

enum CardType { ATTACK, SKILL, POWER, CURSE }
enum TargetType { ENEMY, SELF, ALL_ENEMIES, NONE }

@export_group("Visuals")
@export var id: String
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D

@export_group("Stats")
@export var cost: int = 1
@export var type: CardType = CardType.ATTACK
@export var target: TargetType = TargetType.ENEMY
@export var value: int = 0 # Generic value (Damage, Block amount)

@export_group("Behavior")
@export var script_logic: Script # Optional: Attach custom script for unique effects

func get_modified_cost(player_stats: Dictionary) -> int:
    # Hook for cost reduction logic
    return cost

## EXPERT USAGE:
## Right-click FileSystem -> Create New -> Resource -> CardData.
## Fill in fields. Load these Resources into DeckManager.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — .tres CardData authorship and emit_changed
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — enums/exports for Inspector-safe definitions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
