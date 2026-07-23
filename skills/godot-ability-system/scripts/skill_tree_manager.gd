extends Node
class_name SkillTreeManager

## Progression-only skill tree. Grants abilities to the caster's scene-scoped AbilityManager — never /root combat Autoloads.

signal skill_unlocked(skill_id: StringName, rank: int)
signal points_changed(new_total: int)

var skills: Dictionary = {} # skill_id -> SkillNode (runtime duplicates)
var skill_points: int = 0


func add_skill(skill_template: SkillNode) -> void:
	skills[skill_template.skill_id] = skill_template.duplicate(true)


func can_unlock_skill(skill_id: StringName, player_level: int) -> bool:
	var skill: SkillNode = skills.get(skill_id)
	if skill == null:
		return false
	return skill.can_unlock(skills, player_level, skill_points)


func unlock_skill(skill_id: StringName, player_level: int, ability_manager: Node, stat_owner: Node) -> bool:
	if not can_unlock_skill(skill_id, player_level):
		return false
	var skill: SkillNode = skills[skill_id]
	skill.unlock()
	skill_points -= skill.points_required
	_apply_skill_effects(skill, ability_manager, stat_owner)
	skill_unlocked.emit(skill_id, skill.current_rank)
	points_changed.emit(skill_points)
	return true


func _apply_skill_effects(skill: SkillNode, ability_manager: Node, stat_owner: Node) -> void:
	if skill.unlocks_ability and ability_manager.has_method(&"register_ability"):
		pass # Caller injects AbilityResource assets by id — keep data-driven
	for stat_name: Variant in skill.stat_bonuses.keys():
		var bonus: float = skill.stat_bonuses[stat_name]
		if stat_owner.has_method(&"add_stat_bonus"):
			stat_owner.add_stat_bonus(String(stat_name), bonus)


func add_skill_points(amount: int) -> void:
	skill_points += amount
	points_changed.emit(skill_points)


func reset_tree(refund_points: bool = true) -> void:
	var total_spent := 0
	for skill: SkillNode in skills.values():
		total_spent += skill.current_rank * skill.points_required
		skill.current_rank = 0
	if refund_points:
		skill_points += total_spent
		points_changed.emit(skill_points)
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — Autoload catalog vs scene-scoped cast policy
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist ranks and skill_points
# ---
