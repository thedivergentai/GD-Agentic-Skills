# virtual_list.gd
# [GDSKILLS] godot-ui-containers
# EXPORT_REFERENCE: virtual_list.gd
extends ScrollContainer

## Virtual list pooling for thousands of logical rows with O(1) Control count.
## Pair with a single spacer child to simulate total scroll height.

@export var item_height: float = 32.0
@export var pool_size: int = 16

var massive_data_array: Array = []
var node_pool: Array[Control] = []
var _spacer: Control

func _ready() -> void:
	get_v_scroll_bar().value_changed.connect(_on_scroll)
	_ensure_spacer()

func setup_pool(factory: Callable) -> void:
	for i in pool_size:
		var node: Control = factory.call()
		add_child(node)
		node_pool.append(node)
	_refresh_spacer()
	_on_scroll(get_v_scroll_bar().value)

func set_data(rows: Array) -> void:
	massive_data_array = rows
	_refresh_spacer()
	_on_scroll(get_v_scroll_bar().value)

func _ensure_spacer() -> void:
	if _spacer != null:
		return
	_spacer = Control.new()
	_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_spacer)
	move_child(_spacer, 0)

func _refresh_spacer() -> void:
	_ensure_spacer()
	_spacer.custom_minimum_size = Vector2(0, massive_data_array.size() * item_height)

func _on_scroll(_value: float = 0.0) -> void:
	if node_pool.is_empty() or item_height <= 0.0:
		return
	var scroll_y := get_v_scroll_bar().value
	var start_idx := clampi(int(scroll_y / item_height), 0, maxi(massive_data_array.size() - 1, 0))
	for i in range(node_pool.size()):
		var data_idx := start_idx + i
		var node := node_pool[i]
		if data_idx >= massive_data_array.size():
			node.visible = false
			continue
		node.visible = true
		node.position.y = data_idx * item_height
		if node.has_method(&"update_data"):
			node.call(&"update_data", massive_data_array[data_idx])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_scrollbar.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid thousands of Controls
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — large item lists via pooling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
