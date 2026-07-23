extends Node
## Expert logic for swapping system mouse cursors with themed Easter icons.

func _ready() -> void:
    _apply_easter_cursor()

func _apply_easter_cursor() -> void:
    # Example implementation from reference
    var cursor_img = preload("res://ui/easter/cursor_bunny.png")
    if cursor_img:
        Input.set_custom_mouse_cursor(cursor_img, Input.CURSOR_ARROW, Vector2(16, 16))
    else:
        push_warning("Easter cursor image not found.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — base Theme architecture
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — confetti/shimmer VFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md
# =============================================================================
