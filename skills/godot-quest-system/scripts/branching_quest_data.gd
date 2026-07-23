# branching_quest_data.gd
# Handling multi-outcome quest lines
class_name BranchingQuest extends Quest

# EXPERT NOTE: Allow quests to have multiple "Next" paths 
# based on player choices or hidden stats.

@export var positive_outcome_quest: Quest
@export var negative_outcome_quest: Quest

func resolve_branch(is_positive: bool):
	if is_positive:
		QuestManager.accept_quest(positive_outcome_quest)
	else:
		QuestManager.accept_quest(negative_outcome_quest)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — outcome Quest references as exported Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — player choice resolves positive/negative branch
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
