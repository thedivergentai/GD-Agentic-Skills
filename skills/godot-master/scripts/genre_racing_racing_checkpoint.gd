# racing_checkpoint.gd
extends Area3D
class_name RacingCheckpoint

# Sequential Checkpoint Validation Gate
# Signal-based tracker for lap progression.

@export var checkpoint_index := 0
signal crossed(node: Node3D, idx: int)

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group(&"player"):
        crossed.emit(body, checkpoint_index)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — checkpoint enter ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — Area3D monitoring layers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
