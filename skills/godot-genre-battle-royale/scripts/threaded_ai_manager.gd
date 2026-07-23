# threaded_ai_manager.gd
# Offloading server-side AI to worker threads
extends Node

# EXPERT NOTE: Server CPUs are often the bottleneck. 
# Move bot behavior logic to the WorkerThreadPool.

func process_bots():
	var bot_ids = range(bots.size())
	WorkerThreadPool.add_group_task(_tick_bot, bot_ids.size())

func _tick_bot(index: int):
	# Bot logic running on secondary thread
	# CAUTION: Physics access must be synchronized!
	pass

var bots: Array = []
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md — bot pathfinding off the match tick
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — server CPU isolation for AI
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
