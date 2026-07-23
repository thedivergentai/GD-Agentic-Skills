# GPU Fill Rate Optimization via MeshInstance2D
extends Node2D

## Drawing large transparent areas is expensive for GPUs (Fill Rate bottleneck).
## Use MeshInstance2D to create a tight polygon around your sprite.

func convert_sprite_to_optimized_mesh(sprite: Sprite2D) -> MeshInstance2D:
	# While normally done in the Editor (Sprite2D > "Convert to MeshInstance2D"),
	# this conceptual script highlights the logic.
	
	var mesh_node = MeshInstance2D.new()
	mesh_node.texture = sprite.texture
	
	# Architecture Tip: For thousands of trees/grass, MeshInstance2D is mandatory
	# because it bypasses the transparent alpha blending overhead for empty space.
	
	# In your master scene, prefer MeshInstance2D over Sprite2D for static
	# environmental animations (like swaying trees) to protect your GPU budget.
	return mesh_node
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_meshinstance2d.html
# - https://docs.godotengine.org/en/stable/classes/class_sprite2d.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/introduction_to_2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — mesh materials for swaying props
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md — dense 2D scenery fill-rate pressure
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md
# =============================================================================
