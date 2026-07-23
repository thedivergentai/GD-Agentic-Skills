# scene_integration_test.gd
# Testing full scene interaction
extends GdUnitTestSuite

# EXPERT NOTE: Integration tests ensure that nodes in 
# a scene interact correctly after .instantiate().

func test_ui_button_press():
	var scene = spy("res://menu.tscn")
	var button = scene.get_node("StartButton")
	
	# Simulate user interaction
	button.emit_signal("pressed")
	
	assert_that(scene.is_game_started).is_true()
	scene.free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — scene packing and load fixtures
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — button/pressed paths in menu scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
