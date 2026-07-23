# MultiMesh Swarm Animation Shader Hook
extends MultiMeshInstance2D

## For swarms (birds, fish, projectiles), Node2D overhead is the bottleneck.
## Use a Shader to animate thousands of instances on the GPU.

func _ready() -> void:
	var mat = material as ShaderMaterial
	# Pass the start time to the shader to sync animations
	mat.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)

# Example Shader Snippet (to be put in .gdshader):
# void vertex() {
#     float phase = TIME * speed + (float(INSTANCE_ID) * 0.5);
#     VERTEX.y += sin(phase) * amplitude; // Procedural GPU animation
# }
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/vertex_animation/animating_thousands_of_fish.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimeshinstance2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — INSTANCE_ID phase animation in vertex()
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — when GPUParticles2D is enough vs MultiMesh
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md
# =============================================================================
