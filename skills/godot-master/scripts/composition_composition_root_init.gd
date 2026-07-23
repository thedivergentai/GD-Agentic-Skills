# composition_root_init.gd
# The "Smart Parent" pattern for wiring components
extends CharacterBody2D

# EXPERT NOTE: The parent node acts as the 'orchestrator' or
# 'composition root' that connects disparate components.
# Wire via Inspector @export (or %UniqueNames in the scene) — NEVER $ / get_node.

@export var health: HealthComponent
@export var hitbox: HitBoxComponent
@export var velocity_comp: VelocityComponent

func _ready():
	assert(health != null, "Missing HealthComponent export on %s" % name)
	assert(hitbox != null, "Missing HitBoxComponent export on %s" % name)
	assert(velocity_comp != null, "Missing VelocityComponent export on %s" % name)
	# Wire components together
	hitbox.health_component = health

	# Respond to component signals
	health.health_depleted.connect(_on_death)

func _physics_process(delta):
	# Delegation
	velocity_comp.accelerate_in_direction(Input.get_vector("left", "right", "up", "down"), delta)
	velocity_comp.apply_velocity(self)

func _on_death():
	queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — root connects health_depleted and calls down into workers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — orchestrator CharacterBody2D owns physics tick delegation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — prefer %UniqueNames / @export over fragile $ paths
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
