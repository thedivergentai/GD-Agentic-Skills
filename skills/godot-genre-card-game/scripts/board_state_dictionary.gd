# board_state_dictionary.gd
# Tracking card positions via typed dictionaries
extends Node

# EXPERT NOTE: Dictionaries mapping Vector2i to CardData 
# are better for board logic than 2D Godot node arrays.

var board: Dictionary = {} # Vector2i -> CardData

func place_card(coord: Vector2i, card: CardData):
	if !board.has(coord):
		board[coord] = card
		print("Card placed at ", coord)

func get_card_at(coord: Vector2i) -> CardData:
	return board.get(coord)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Dictionary[Vector2i] board models vs node order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — store CardData refs, not Control nodes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
