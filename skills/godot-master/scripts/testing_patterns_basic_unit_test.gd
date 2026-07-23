# basic_unit_test.gd
# Minimal GdUnit4 test structure
extends GdUnitTestSuite

# EXPERT NOTE: In GdUnit4, use verify() and assert_that() 
# for readable, robust unit testing of logic scripts.

func test_arithmetic_logic():
	assert_that(1 + 1).is_equal(2)
	assert_that("Godot").is_not_empty()

func test_player_damage():
	var player = Player.new()
	player.take_damage(20)
	assert_that(player.health).is_equal(80)
	player.free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed asserts and pure-logic unit tests
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — where test scripts live in project layout
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
