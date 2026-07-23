# wait_for_frame_test.gd
# Testing asynchronous behavior
extends GdUnitTestSuite

# EXPERT NOTE: Use await yield_signal() or yield_frames() 
# in GdUnit4 to test logic that spans multiple frames.

func test_delayed_respawn():
	var player = Player.new()
	player.die()
	
	# Wait for the respawn timer to finish
	await yield_seconds(2.0)
	
	assert_that(player.is_alive).is_true()
	player.free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — await/process_frame timing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — multi-frame tween completion under test
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
