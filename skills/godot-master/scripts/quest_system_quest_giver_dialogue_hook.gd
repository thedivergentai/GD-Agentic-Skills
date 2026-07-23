# quest_giver_dialogue_hook.gd
# Interfacing quests with a dialogue system
extends Node

# EXPERT NOTE: The NPC logic should check the QuestManager state 
# to decide which dialogue branch to play.

@export var quest_to_give: Quest

func interact():
	var q_status = QuestManager.get_quest_status(quest_to_give.id)
	
	match q_status:
		Quest.Status.AVAILABLE:
			_show_offer_dialogue()
		Quest.Status.ACTIVE:
			_show_reminder_dialogue()
		Quest.Status.COMPLETED:
			_show_thanks_dialogue()

func _show_offer_dialogue():
	# If player accepts in UI:
	QuestManager.accept_quest(quest_to_give)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — offer/reminder/thanks lines from quest status
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — query QuestManager Autoload from NPC interact
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
