# offscreen_logic_suspender.gd
extends Node

# Suspending Off-Screen AI (CPU Optimization)
# Used in conjunction with VisibleOnScreenNotifier3D to save cycles.
func _on_screen_exited() -> void:
    # Disabling physics processing reclaims CPU cycles when the monster isn't visible.
    # CRITICAL: Ensure visual-only effects (sound cues) handle this state carefully.
    set_physics_process(false)

func _on_screen_entered() -> void:
    # Resume immediately when entering player frustum.
    set_physics_process(true)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_visibleonscreennotifier3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — disable AI far from frustum
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — notifier tracks active camera frustum
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — pause agents when suspended
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
