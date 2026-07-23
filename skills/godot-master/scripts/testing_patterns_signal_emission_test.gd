# signal_emission_test.gd
# Verifying signal behavior in tests
extends GdUnitTestSuite

# EXPERT NOTE: Verifying that signals fire correctly is 
# critical for decoupled Godot architectures.

func test_signal_fired_on_death():
	var player = Player.new()
	var monitor = monitor_signals(player)
	
	player.health = 0
	player.check_death()
	
	verify(monitor).is_emitted("died")
	player.free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — emit/connect contracts under test
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — signal typing and callable patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
