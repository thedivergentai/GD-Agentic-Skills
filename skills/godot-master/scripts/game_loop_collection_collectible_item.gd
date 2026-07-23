class_name CollectibleItem
extends Area3D

## Pickup actor: unique item_id within a collection_id hunt.
## One-shot Area overlap — monitoring disabled after first collect.

# Hunt category (e.g. "red_eggs_2024")
@export var collection_id: String = "easter_egg"

# Stable per-instance ID (e.g. "red_egg_07") — required for saves and compass
@export var item_id: String = ""

@export var consume_on_collect: bool = true
@export var vfx_on_collect: PackedScene

signal item_collected(collection_id: String, item_id: String)

var _already_collected: bool = false


func _ready() -> void:
	add_to_group(&"collectible")

	if item_id.is_empty():
		push_warning("CollectibleItem: item_id must be set on '%s'" % name)

	body_entered.connect(_on_body_entered)
	_sync_with_manager()


func _sync_with_manager() -> void:
	var manager := _get_manager()
	if manager and not item_id.is_empty() and manager.is_item_collected(collection_id, item_id):
		_disable_pickup()


func _on_body_entered(body: Node) -> void:
	if _already_collected:
		return
	if body.is_in_group(&"player"):
		collect()


func collect() -> void:
	if _already_collected:
		return

	_already_collected = true
	monitoring = false
	monitorable = false

	if vfx_on_collect:
		var vfx = vfx_on_collect.instantiate()
		get_parent().add_child(vfx)
		vfx.global_position = global_position

	item_collected.emit(collection_id, item_id)

	var manager := _get_manager()
	if manager:
		manager.register_item(collection_id, item_id)

	if consume_on_collect:
		queue_free()


func _disable_pickup() -> void:
	_already_collected = true
	monitoring = false
	monitorable = false
	hide()


func _get_manager() -> CollectionManager:
	return get_tree().get_first_node_in_group(&"collection_manager") as CollectionManager

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — Area3D layers/masks and shape scaling rules
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — vfx_on_collect before queue_free
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — pickup one-shots on item_collected
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md
# =============================================================================
