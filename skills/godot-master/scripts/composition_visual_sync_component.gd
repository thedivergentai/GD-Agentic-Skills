# visual_sync_component.gd
# Separating logic from visuals
class_name VisualSyncComponent extends Node

# EXPERT NOTE: This component syncs a Sprite or Mesh to the 
# parent's logical state (e.g., flipping based on velocity).

@export var sprite: Sprite2D
@export var velocity_component: VelocityComponent

func _process(_delta: float) -> void:
	if sprite and velocity_component:
		if velocity_component.velocity.x != 0:
			sprite.flip_h = velocity_component.velocity.x < 0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — flip/sync sprite presentation from logical velocity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — optional future: drive flips from moved signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
