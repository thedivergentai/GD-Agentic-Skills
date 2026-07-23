# reactive_oneshot_vfx.gd
# Using AnimationNodeOneShot for high-priority reactive animations
extends AnimationTree

# Use OneShot nodes for non-looping animations that should override the 
# current state (recoil, blinks, hit reactions).

func trigger_recoil() -> void:
	# OneShot nodes have a 'request' parameter
	# AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE = 1
	set("parameters/Recoil/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func cancel_oneshot(node_name: String) -> void:
	# AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT = 2
	set("parameters/" + node_name + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodeoneshot.html
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hitreact / recoil overlays
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — VFX spawned beside OneShot FIRE
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
