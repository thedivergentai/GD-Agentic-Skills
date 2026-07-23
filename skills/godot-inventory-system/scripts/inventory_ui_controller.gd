# inventory_ui_controller.gd
# Mapping data to visual representations
extends GridContainer

# EXPERT NOTE: The UI should listen to the Data Resource.
# Reuse slot controls — never queue_free the whole grid on every update.

@export var inventory_data: InventoryData
@export var slot_scene: PackedScene

var _slot_uis: Array[Node] = []

func _ready() -> void:
	if inventory_data:
		inventory_data.inventory_updated.connect(_on_inventory_updated)
		_ensure_slot_count()
		_render_inventory()

func _ensure_slot_count() -> void:
	if slot_scene == null or inventory_data == null:
		return
	while _slot_uis.size() < inventory_data.slots.size():
		var slot_ui := slot_scene.instantiate()
		add_child(slot_ui)
		_slot_uis.append(slot_ui)
	while _slot_uis.size() > inventory_data.slots.size():
		var extra: Node = _slot_uis.pop_back()
		extra.queue_free()

func _render_inventory() -> void:
	_ensure_slot_count()
	for i in range(_slot_uis.size()):
		var slot_ui := _slot_uis[i]
		if slot_ui.has_method("set_slot_data"):
			slot_ui.set_slot_data(inventory_data.slots[i])

func _on_inventory_updated() -> void:
	_render_inventory()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# - https://docs.godotengine.org/en/stable/classes/class_gridcontainer.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — GridContainer slot layout
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — UI listens; data owns mutations
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
