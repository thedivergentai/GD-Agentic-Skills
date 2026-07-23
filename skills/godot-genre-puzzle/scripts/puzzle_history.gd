# puzzle_history.gd
extends Node
class_name PuzzleHistory

# Action Command Pattern (Undo/Redo System)
# Robust undo history keeping "do" and "undo" methods strictly separated.

var undo_redo := UndoRedo.new()

func execute_move(node: Node2D, target_position: Vector2) -> void:
    undo_redo.create_action("Move Piece")
    
    # Expert Pattern: Group 'do' on one side and 'undo' on the other.
    undo_redo.add_do_property(node, "position", target_position)
    undo_redo.add_undo_property(node, "position", node.position)
    
    undo_redo.commit_action()

func undo_last_move() -> void:
    if undo_redo.has_undo():
        undo_redo.undo()

func redo_last_move() -> void:
    if undo_redo.has_redo():
        undo_redo.redo()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_undoredo.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — notify HUD after commit_action
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
