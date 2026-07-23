class_name RevivalCheckpointPersistence
extends Resource

## Expert Checkpoint Persistence Resource.
## Stores the last activated checkpoint and associated world state.

@export var last_checkpoint_id: String = ""
@export var checkpoint_pos: Vector3 = Vector3.ZERO
@export var triggered_events: Array[String] = []

func save_state() -> void:
	ResourceSaver.save(self, "user://checkpoint_data.res")

static func load_state() -> RevivalCheckpointPersistence:
	if ResourceLoader.exists("user://checkpoint_data.res"):
		return ResourceLoader.load("user://checkpoint_data.res")
	return RevivalCheckpointPersistence.new()

## Tip: Resource-based saving is faster and more type-safe for checkpoint data than JSON.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — checkpoint Resource payload
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html — ResourceSaver.save to user://
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html — user://checkpoint_data.res path
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — typed checkpoint Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — durable save contract beyond RAM
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
