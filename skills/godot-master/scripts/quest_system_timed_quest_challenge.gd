# timed_quest_challenge.gd
# Adding temporal constraints to quest logic
class_name TimedQuest extends Quest

@export var time_limit: float = 60.0

func start_timer():
	get_tree().create_timer(time_limit).timeout.connect(_on_fail)

func _on_fail():
	if status == Status.ACTIVE:
		status = Status.FAILED
		QuestManager.notify_quest_failed(id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_timer.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — timeout → fail signal without _process polling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune time_limit fail rates before shipping
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
