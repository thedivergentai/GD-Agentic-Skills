extends Node
class_name PuzzleUndoManager

## Expert Undo/Redo (Godot 4.7).
## Leverages the built-in UndoRedo class for command tracking.

var history := UndoRedo.new()

func record_move(piece: Node2D, from: Vector2i, to: Vector2i) -> void:
	history.create_action("Move Piece")
	history.add_do_method(piece.move_to.bind(to))
	history.add_undo_method(piece.move_to.bind(from))
	history.commit_action()

func undo() -> void:
	if history.has_undo(): history.undo()

func redo() -> void:
	if history.has_redo(): history.redo()

## [SKILL NOTICE]: Do not build custom stacks. Use Godot's 'UndoRedo' 
## object to handle the Command pattern and memory limits automatically.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_undoredo.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — bind undo/redo actions from keyboard/gamepad
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
