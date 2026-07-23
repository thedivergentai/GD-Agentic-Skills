# smart_oneshot_recycler.gd
# Robust lifecycle management for one-shot VFX
extends GPUParticles3D

func _ready() -> void:
	one_shot = true
	# Relying on the 'finished' signal is the ONLY safe way to free VFX [40].
	finished.connect(_on_vfx_finished)
	emitting = true

func _on_vfx_finished() -> void:
	# Handle recycling or freeing
	queue_free()

func trigger_restart() -> void:
	# Anti-pattern fix: setting emitting=true directly after finished 
	# can fail due to GPU async state. Use restart() instead [41].
	restart()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/properties.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — finished connections for pool return/free
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — restart() vs emitting=true after GPU async finish
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
