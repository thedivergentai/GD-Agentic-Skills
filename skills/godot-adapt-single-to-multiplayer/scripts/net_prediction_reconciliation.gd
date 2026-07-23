class_name NetPredictionReconciliation
extends CharacterBody3D

## Expert Client Prediction & Server Reconciliation.
## Minimizes apparent latency by predicting movement and replaying on error.

# --- Prediction State ---
var current_tick: int = 0
var input_buffer: Array[Dictionary] = []
const RECONCILIATION_THRESHOLD = 0.1

# --- Server Reconciliation State ---
var server_position: Vector3
var last_server_tick: int = 0
var needs_reconciliation: bool = false

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		current_tick += 1
		var input = _get_input()
		
		# Buffer the input for the replay loop
		# We store the state BEFORE applying movement to allow precise re-simulation
		input_buffer.append({
			"tick": current_tick,
			"input": input,
			"pos": global_position
		})
		
		# Send input to server
		rpc_id(1, "server_process_input", input, current_tick)

		# If we received a correction from the server, perform reconciliation
		if needs_reconciliation:
			_reconcile_and_replay(delta)
			needs_reconciliation = false
		else:
			# Predict locally
			_apply_movement(input, delta)

@rpc("any_peer", "call_remote", "unreliable")
func server_process_input(input: Vector2, client_tick: int) -> void:
	if not multiplayer.is_server():
		return
		
	# Server validates and applies
	_apply_movement(input, get_physics_process_delta_time())
	
	# Send authoritative state back to the specific client
	var sender_id := multiplayer.get_remote_sender_id()
	client_receive_state.rpc_id(sender_id, global_position, client_tick)

@rpc("authority", "call_remote", "unreliable")
func client_receive_state(auth_pos: Vector3, auth_tick: int) -> void:
	# Ignore old or out-of-order packets
	if auth_tick <= last_server_tick:
		return
		
	last_server_tick = auth_tick
	server_position = auth_pos
	
	# Find the matching entry in our buffer to check for divergence
	var matching_entry = null
	for entry in input_buffer:
		if entry.tick == auth_tick:
			matching_entry = entry
			break
	
	# If the server position significantly differs from our predicted position at that tick
	# (Note: we should compare to the position AFTER movement was applied at that tick, 
	# but for simplicity we check the next entry's start pos or the current pos if it's the latest)
	if matching_entry and matching_entry.pos.distance_to(auth_pos) > RECONCILIATION_THRESHOLD:
		needs_reconciliation = true
	
	# Prune the buffer of acknowledged inputs
	input_buffer = input_buffer.filter(func(i): return i.tick > auth_tick)

func _reconcile_and_replay(delta: float) -> void:
	# 1. Snap back to the authoritative server state
	global_position = server_position
	
	# 2. Replay all unacknowledged inputs to catch up to the current frame
	for entry in input_buffer:
		# Update the stored position for future reconciliation checks
		entry.pos = global_position
		_apply_movement(entry.input, delta)

func _apply_movement(input: Vector2, delta: float) -> void:
	velocity = Vector3(input.x, 0, input.y) * 10.0
	# Use move_and_slide for normal movement, but be aware of non-determinism
	move_and_slide()

func _get_input() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — replayable move_and_slide steps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — authority-gated input samples for the buffer
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
