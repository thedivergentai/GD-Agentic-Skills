# rhythm_ui_feedback.gd
extends Control
class_name RhythmUIFeedback

# Visual Response for Hit Quality
# Spawns transient labels indicating Early/Late/Perfect status.

@export var feedback_colors: Dictionary = {
    "PERFECT": Color.GOLD,
    "GOOD": Color.CYAN,
    "OK": Color.GREEN,
    "MISS": Color.RED
}

func show_feedback(result_name: String) -> void:
    var label = Label.new()
    label.text = result_name
    label.modulate = feedback_colors.get(result_name, Color.WHITE)
    add_child(label)
    
    var tween = create_tween()
    # Pattern: Fade out and move up simultaneously.
    tween.set_parallel(true)
    tween.tween_property(label, "position:y", label.position.y - 50, 0.4)
    tween.tween_property(label, "modulate:a", 0.0, 0.4)
    tween.chain().tween_callback(label.queue_free)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — fade/rise judgment splash
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — HUD layer for feedback labels
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — Perfect hit particle bursts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
