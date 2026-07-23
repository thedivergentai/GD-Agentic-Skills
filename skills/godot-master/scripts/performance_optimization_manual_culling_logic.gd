# manual_culling_logic.gd
# Disabling off-screen logic manually
extends VisibleOnScreenNotifier2D

# EXPERT NOTE: VisibilityNotifiers are the most efficient 
# way to cull heavy _process or _physics_process logic 
# when nodes are not visible to the camera.

func _ready():
	screen_entered.connect(_on_screen_entered)
	screen_exited.connect(_on_screen_exited)

func _on_screen_entered():
	set_process(true)
	set_physics_process(true)

func _on_screen_exited():
	set_process(false)
	set_physics_process(false)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_visibleonscreennotifier2d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — camera frustum drives on-screen enter/exit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — occlusion/LOD layout for large levels
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
