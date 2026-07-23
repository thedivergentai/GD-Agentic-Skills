# one_shot_deferred_connections.gd
# Specialized connection flags for physics and cleanup
extends Node

# EXPERT NOTE: 
# CONNECT_ONE_SHOT: Disconnects automatically after firing.
# CONNECT_DEFERRED: Runs at the end of the frame (safe for physics changes).

func _ready():
	# Executes once, then cleans up. Deferred ensures physics space is unlocked.
	$DeathTrigger.body_entered.connect(_on_death, CONNECT_ONE_SHOT | CONNECT_DEFERRED)

func _on_death(_body):
	get_tree().reload_current_scene()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_object.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — deferred reload after body_entered
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — CONNECT_DEFERRED for physics-space-safe callbacks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
