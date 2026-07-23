class_name NetRollbackHelper
extends Node

## Expert Rollback Helper for state snapshots and re-simulation.
## Buffers historical states and inputs to allow retroactive correction.

# Maximum frames to keep in the rollback buffer (approx 1s at 60fps)
const BUFFER_SIZE := 64

# Ring buffers for historical data
var _state_buffer: Array[Dictionary] = []
var _input_buffer: Array[Dictionary] = []

func _ready() -> void:
	# Pre-allocate buffers
	for i in range(BUFFER_SIZE):
		_state_buffer.append({})
		_input_buffer.append({})

## Records the current state and input for a specific tick.
func save_snapshot(tick: int, state: Dictionary, input: Dictionary) -> void:
	var idx = tick % BUFFER_SIZE
	# deep duplicate to prevent reference overrides
	_state_buffer[idx] = state.duplicate(true)
	_input_buffer[idx] = input.duplicate(true)

## Retrieves a historical snapshot.
func get_snapshot(tick: int) -> Dictionary:
	return _state_buffer[tick % BUFFER_SIZE]

## Retrieves historical input.
func get_input(tick: int) -> Dictionary:
	return _input_buffer[tick % BUFFER_SIZE]

## Triggers a rollback and re-simulation cycle.
## target_node must implement 'apply_state(state)' and 'process_simulation_step(delta, input)'.
func rollback_and_resimulate(server_tick: int, current_tick: int, server_state: Dictionary, target_node: Node) -> void:
	# 1. Snap to authoritative server state
	if target_node.has_method("apply_state"):
		target_node.apply_state(server_state)
	
	var delta = target_node.get_physics_process_delta_time()
	
	# 2. Re-simulate from server_tick up to the present
	for tick in range(server_tick, current_tick):
		var hist_input = get_input(tick)
		
		# Step the logic forward
		if target_node.has_method("process_simulation_step"):
			target_node.process_simulation_step(delta, hist_input)
		
		# Re-save the corrected prediction
		if target_node.has_method("get_current_state"):
			save_snapshot(tick + 1, target_node.get_current_state(), hist_input)
	
	# 3. Clean up interpolation to prevent visual snapping
	if target_node is Node3D or target_node is Node2D:
		target_node.reset_physics_interpolation()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — rollback/resim migration patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md — fixed-tick rollback consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
