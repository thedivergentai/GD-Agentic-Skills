# sync_group_layering.gd
# Using Sync Groups to keep multi-layered animations aligned [292]
extends AnimationTree

# PROBLEM: Upper body 'Reload' and Lower body 'Walk' have different lengths.
# SOLUTION: Use Sync Groups to force them to share a normalized timeline (0.0 - 1.0).

func setup_reload_sync() -> void:
	# This logic usually happens in the BlendTree editor, but scriptable here:
	var root: AnimationNodeBlendTree = tree_root
	var blend_node = root.get_node("ReloadLayer")
	
	# Enable 'sync' on the Blend2 or Add2 node combining the layers
	# This ensures the secondary animation follows the primary's phase.
	# Note: In Godot 4, this is the 'sync' property on AnimationNodeSync nodes.
	pass # Logic primarily configuration-based
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodesync.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodeblendtree.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — reload/walk phase alignment
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — layered cycles that still need Sync
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
