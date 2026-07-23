# texture_array_batching.gd
# Reducing state changes with TextureArrays
extends Node

# EXPERT NOTE: Switching textures is a slow "state change" 
# for GPUs. Using Texture2DArray or Atlases allows 
# the RenderingServer to batch multiple draw calls into one.

@export var tex_array: Texture2DArray

func apply_material_index(sprite: Sprite2D, index: int):
	sprite.material.set_shader_parameter("layer_index", index)
	# Shader then pulls from tex_array[index]
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_texture2darray.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/pipeline_compilations.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — sampler2DArray shader sampling for batched draws
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — material setup that feeds array layers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
