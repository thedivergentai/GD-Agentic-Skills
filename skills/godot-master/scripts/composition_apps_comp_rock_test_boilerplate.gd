class_name CompRockTestBoilerplate
extends Node

## Expert 'Rock Test' debug utility.
## Validates if a component is truly decoupled and context-agnostic.

func run_rock_test(component: Node) -> void:
	var rock = Node.new()
	rock.name = "LiteralRock"
	add_child(rock)
	
	rock.add_child(component)
	print("Testing Component: ", component.name)
	
	# If the component throws errors because 'get_parent()' isn't a Player, it FAILS.
	# Proper components should just sit on the rock waiting for signals/calls.

## Tip: Run this test during development to catch hard-coupling early.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — isolate component rock tests
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — context-agnostic Has-A validation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
