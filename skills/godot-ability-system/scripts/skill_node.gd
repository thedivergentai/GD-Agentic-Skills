extends Resource
class_name SkillNode

## Single node in a skill-tree graph. Runtime rank lives on duplicated instances — never mutate shared .tres templates.

@export var skill_id: StringName
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D

@export_group("Requirements")
@export var prerequisites: Array[StringName] = []
@export var character_level_required: int = 1
@export var points_required: int = 1
@export var mutually_exclusive_with: Array[StringName] = []

@export_group("Progression")
@export var max_rank: int = 1
@export var current_rank: int = 0

@export_group("Effects")
@export var unlocks_ability: StringName
@export var stat_bonuses: Dictionary = {}


func can_unlock(player_skills: Dictionary, player_level: int, available_points: int) -> bool:
	if current_rank >= max_rank:
		return false
	if available_points < points_required:
		return false
	if player_level < character_level_required:
		return false
	for prereq_id: StringName in prerequisites:
		if not player_skills.has(prereq_id):
			return false
		var node: SkillNode = player_skills[prereq_id]
		if node.current_rank == 0:
			return false
	for exclusive_id: StringName in mutually_exclusive_with:
		if player_skills.has(exclusive_id):
			var other: SkillNode = player_skills[exclusive_id]
			if other.current_rank > 0:
				return false
	return true


func unlock() -> void:
	current_rank += 1
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — duplicate(true) before assigning ranks at runtime
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — stat_bonuses application
# ---
