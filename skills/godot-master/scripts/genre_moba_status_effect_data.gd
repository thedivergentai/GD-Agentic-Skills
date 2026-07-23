# status_effect_data.gd
extends Resource
class_name StatusEffectData

# Resource-Based Status Effect Data
# Lightweight persistent container for MOBA buffs/debuffs.

@export var effect_id: StringName = &"stun"
@export var duration: float = 1.0
@export var speed_multiplier: float = 1.0
@export var damage_over_time: int = 0
@export var is_cleansable: bool = true
@export var icon: Texture2D
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — buff multipliers on hero stats
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — effect payload resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
