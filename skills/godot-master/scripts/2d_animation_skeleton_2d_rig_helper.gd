# Expert 2D IK and Skeleton Setup
extends Skeleton2D

## Note: In Godot 4.x, 2D IK is primarily handled via the "SkeletonModificationStack2D".
## This script demonstrates programmatic setup and modification of bone constraints.

@onready var modification_stack: SkeletonModificationStack2D = get_modification_stack()

func _ready() -> void:
	# Ensure the stack is enabled
	modification_stack.enabled = true
	setup_ik_constraint()

func setup_ik_constraint() -> void:
	# Logic to find or create a FABRIK or CCDIK modification at runtime
	if modification_stack.get_modification_count() == 0:
		# Programmatic adding of IK is advanced; usually done via editor
		# but properties can be tuned here.
		push_warning("Ensure a modification stack is added in the editor for this script to tune it.")
		return
	
	var mod = modification_stack.get_modification(0)
	if mod is SkeletonModification2DFABRIK:
		mod.target_nodepath = get_parent().get_path_to($"../TargetMarker")
		mod.chain_length = 3 # Number of bones to affect upward from the tip
		print("IK Target successfully synced to TargetMarker")

func update_bone_rest_pose(bone_name: String, new_transform: Transform2D) -> void:
	var bone = find_child(bone_name) as Bone2D
	if bone:
		bone.rest = new_transform
		# Mandatory for the skeleton to recognize the change
		bone.apply_rest()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/2d_skeletons.html
# - https://docs.godotengine.org/en/stable/classes/class_skeleton2d.html
# - https://docs.godotengine.org/en/stable/classes/class_skeletonmodificationstack2d.html
# - https://docs.godotengine.org/en/stable/classes/class_skeletonmodification2dtwoboneik.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — bone rotation tracks on Skeleton2D
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — raycast IK targets for feet
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md
# =============================================================================
