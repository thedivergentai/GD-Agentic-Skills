# break_on_condition.gd
# Forcing the debugger to halt on invalid states
extends Node

# EXPERT NOTE: Hardcoded breakpoints are team-agnostic 
# and don't rely on ephemeral editor UI configuration.

func validate_player_state(p: Node):
	if p == null:
		# Editor halts here immediately
		breakpoint
	
	if p.get("health") != null and p.health < -100:
		# Catching extreme overflows
		breakpoint
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/debugger_panel.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — breakpoint keyword and asserts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — fail-fast invalid state checks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
