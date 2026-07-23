class_name GameFeelHelper extends Node

func apply_squash_and_stretch(visual_node: Node2D, target_scale: Vector2, duration: float) -> void:
    var tween := visual_node.create_tween()
    tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    # Squash
    tween.tween_property(visual_node, "scale", target_scale, duration)
    # Return to normal
    tween.tween_property(visual_node, "scale", Vector2.ONE, duration)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
