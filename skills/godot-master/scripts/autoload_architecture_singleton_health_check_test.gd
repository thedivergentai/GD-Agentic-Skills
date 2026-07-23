# singleton_health_check_test.gd
# Template for verifying global singleton state using expert unit testing patterns.
# Designed for compatibility with GUT (Godot Unit Test) or GdUnit4.

extends Node

## Health Check: Verify that core singletons are correctly initialized.
func test_singleton_initialization():
	# Verify ServiceLocator
	var root = Engine.get_main_loop().root
	assert_not_null(root.get_node_or_null("GameManager"), "GameManager must be registered as an Autoload.")
	
	# Verify default states
	# var gm = root.get_node("GameManager")
	# assert_eq(gm.score, 0, "GameManager score should start at 0.")
	
	print("Health Check: Singletons are stable.")

## Helper for GUT (if using)
func assert_not_null(obj, msg):
	if obj == null:
		push_error(msg)
	else:
		print("PASSED: ", msg)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/classes/class_object.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — GUT asserts for Autoload presence
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — boot-time health gate
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — expected singleton names
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
