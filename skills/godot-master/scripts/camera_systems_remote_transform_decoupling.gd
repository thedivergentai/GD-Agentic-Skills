# remote_transform_decoupling.gd
# Decoupling Camera from Player hierarchy using RemoteTransform2D [30]
extends Node2D

# EXPERT NOTE: Avoid parenting the Camera directly to the Player. 
# Using RemoteTransform2D prevents player rotation/scale from 
# affecting the camera while keeping position sync.

@onready var remote: RemoteTransform2D = RemoteTransform2D.new()
@export var camera: Camera2D

func _ready() -> void:
	add_child(remote)
	remote.remote_path = camera.get_path()
	
	# Configure what to sync
	remote.update_position = true
	remote.update_rotation = false # Camera stays upright
	remote.update_scale = false    # Camera stays at 1:1
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_remotetransform2d.html
# - https://docs.godotengine.org/en/stable/classes/class_camera2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — avoid parenting camera under physics body
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — diagnose rotation/scale bleed into view
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — remote_path setup and update flags
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
