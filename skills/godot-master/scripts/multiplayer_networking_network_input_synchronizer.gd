# network_input_synchronizer.gd
# Handling latency with input replication
extends MultiplayerSynchronizer

# EXPERT NOTE: Sync only the essential inputs, not the 
# calculated physics state, to save bandwidth.

@export var input_direction: Vector2

func _ready():
	# Configure what to sync in the Inspector (SceneReplicationConfig)
	pass

func _physics_process(_delta):
	if is_multiplayer_authority():
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — InputMap → network intent packets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — prediction-ready input buffers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
