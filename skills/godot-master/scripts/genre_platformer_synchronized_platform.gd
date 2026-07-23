# synchronized_platform.gd
extends AnimatableBody2D
class_name SynchronizedPlatform

# Synchronized Moving Platform
# Ensures platforms move flawlessly in sync with the physics tick.

func _ready() -> void:
    # Pattern: Mandatory for platforms moved by AnimationPlayer/Tweens.
    sync_to_physics = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — sync_to_physics moving platforms
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — tweened platform paths with physics sync
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
