# performance_character_pooling.gd
# Managing 100+ active character bodies via visibility
extends CharacterBody2D

# EXPERT NOTE: Characters off-screen should not run physics.

func _physics_process(_delta: float) -> void:
	# In built-in Godot, use VisibleOnScreenNotifier2D to 
	# toggle 'set_physics_process(false)'
	pass

func _on_screen_entered():
	set_physics_process(true)

func _on_screen_exited():
	set_physics_process(false)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — pool vs spawn CharacterBodies
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — deferred free and instance reuse
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
