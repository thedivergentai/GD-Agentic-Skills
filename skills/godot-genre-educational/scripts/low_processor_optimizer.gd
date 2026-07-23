# low_processor_optimizer.gd
# Reducing CPU usage for stationary educational screens
extends Node

# EXPERT NOTE: Enabling low_processor_mode saves battery on 
# student laptops during non-animated quiz sections.

func toggle_optimization(enable: bool):
	OS.low_processor_usage_mode = enable
	# Set max sleep if enabled to further reduce draw frequency
	if enable:
		OS.low_processor_usage_mode_sleep_usec = 6900 # ~144hz limit
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/index.html
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — battery/idle CPU budgets on school laptops
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — OS / display project settings
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — disable low-processor mode during juice
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
