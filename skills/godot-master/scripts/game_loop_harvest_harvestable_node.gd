# harvestable_node.gd
# [GDSKILLS] godot-game-loop-harvest
# EXPORT_REFERENCE: harvestable_node.gd

extends StaticBody3D

signal harvested(data: HarvestResourceData, amount: int)
signal took_damage(current_health: int, max_health: int)
signal interaction_failed(reason: StringName) # Feedback for &"wrong_tool" or &"low_tier"

@export var resource_data: HarvestResourceData
@export var mesh_to_shake: Node3D # "Hit Juice" visual target
@export var respawn_manager: Node # (Optional) Global HarvestRespawnManager

var current_health: int
var _original_mesh_pos: Vector3

func _ready() -> void:
	if not respawn_manager:
		respawn_manager = get_node_or_null("/root/HarvestRespawnManager")
		
	if resource_data:
		current_health = resource_data.health
	if mesh_to_shake:
		_original_mesh_pos = mesh_to_shake.position

func apply_hit(tool: HarvestToolData) -> void:
	# 1. Tool-Specific Validation (enums — never free-form strings)
	if resource_data.required_tool_type != HarvestToolData.ToolType.ANY 			and tool.tool_type != resource_data.required_tool_type:
		interaction_failed.emit(&"wrong_tool")
		return

	if tool.tier < resource_data.required_tier:
		interaction_failed.emit(&"low_tier")
		return
		
	# 2. Damage Logic
	current_health -= tool.damage
	took_damage.emit(current_health, resource_data.health)
	
	# 3. Hit Juice (Shake the mesh)
	_apply_hit_juice()
	
	if current_health <= 0:
		_on_depleted()

func _apply_hit_juice() -> void:
	if not mesh_to_shake: return
	
	var tween = create_tween()
	var shake_offset = Vector3(randf_range(-0.1, 0.1), 0, randf_range(-0.1, 0.1))
	tween.tween_property(mesh_to_shake, "position", _original_mesh_pos + shake_offset, 0.05)
	tween.tween_property(mesh_to_shake, "position", _original_mesh_pos, 0.05)

func _on_depleted() -> void:
	var yield_amount = randi_range(resource_data.yield_range.x, resource_data.yield_range.y)
	
	# Instance item scene if it exists (e.g. drop gems or logs)
	if resource_data.item_scene:
		var item = resource_data.item_scene.instantiate()
		get_parent().add_child(item)
		if item is Node3D:
			item.global_position = global_position
	
	harvested.emit(resource_data, yield_amount)
	
	if respawn_manager and respawn_manager.has_method("register_depletion"):
		respawn_manager.register_depletion(self, resource_data.respawn_time)
	else:
		_hide_and_wait()

func _hide_and_wait() -> void:
	collision_layer = 1 << 15 # Layer 16 (Inactive)
	hide()
	await get_tree().create_timer(resource_data.respawn_time).timeout
	respawn()

func respawn() -> void:
	current_health = resource_data.health
	collision_layer = 1 << 0 # Layer 1 (World)
	show()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_staticbody3d.html — world harvest collider entity
# - https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html — layer swap on deplete/respawn
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — harvested/took_damage/interaction_failed
# - https://docs.godotengine.org/en/stable/classes/class_tween.html — mesh hit-shake juice
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — local create_timer respawn fallback
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — StaticBody3D layers for interactables
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — player raycast → apply_hit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — extend hit juice beyond position shake
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — surface harvest signals to HUD/inventory
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md
# =============================================================================
