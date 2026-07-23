# active_animation_culler.gd
# High-performance: Disabling AnimationPlayers when not visible [317]
extends VisibleOnScreenNotifier3D

@onready var anim_player: AnimationPlayer = get_node("../AnimationPlayer")

func _ready() -> void:
	screen_entered.connect(_on_visible)
	screen_exited.connect(_on_invisible)

func _on_visible() -> void:
	# Resume processing
	anim_player.active = true
	# Optional: speed up to catch up to global sync time if needed
	# anim_player.advance(delta_since_exit)

func _on_invisible() -> void:
	# Disabling 'active' stops all track processing saving CPU/GPU
	# significantly more than 'pause()'.
	anim_player.active = false

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_visibleonscreennotifier3d.html
# - https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_animationmixer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — off-screen AnimationPlayer.active budgets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — validate cull savings in the profiler
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
