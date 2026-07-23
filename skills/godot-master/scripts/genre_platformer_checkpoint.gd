class_name Checkpoint extends Area2D

@export var checkpoint_id: StringName

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        SaveManager.current_checkpoint_pos = global_position
        SaveManager.last_checkpoint_id = checkpoint_id
        # Play visual/audio feedback
        play_activation_effects()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
