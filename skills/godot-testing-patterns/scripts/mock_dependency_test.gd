# mock_dependency_test.gd
# Using Mocks to isolate test subjects
extends GdUnitTestSuite

# EXPERT NOTE: Mocking allows you to test a class without 
# requiring its real dependencies (e.g. Database, Network).

func test_inventory_save():
	var mock_storage = mock(StorageProvider)
	var inventory = Inventory.new()
	inventory.storage = mock_storage
	
	inventory.save()
	
	verify(mock_storage).save_data(any_dictionary())
	inventory.free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource/provider seams to mock
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — storage providers commonly doubled in tests
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
