# beat_synced_animator.gd
extends Node
class_name BeatSyncedAnimator

# Tweening Tied to Conductor Pulses
# Synchronizes visual bounces/scales with the conductor's beat.

func pulse_node(target: CanvasItem) -> void:
    var tween = target.create_tween()
    # Pattern: Use TRANS_ELASTIC or TRANS_BACK for rhythmic bounce feel.
    target.scale = Vector2(1.2, 1.2)
    tween.tween_property(target, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — TRANS/EASE for receptor pulses
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — sprite pulse alternatives to Tween
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — beat boundaries from the conductor
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
