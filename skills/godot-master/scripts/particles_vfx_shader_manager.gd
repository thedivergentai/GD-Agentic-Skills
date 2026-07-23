# skills/particles/code/vfx_shader_manager.gd
extends Node

## VFX Shader Manager Expert Pattern
## Manages custom ParticleShaders and visibility-driven culling.

@export var fx_root: Node3D
@export var gpu_particles: GPUParticles3D

func _ready() -> void:
    # 1. Custom Particle Shader Assignment
    # Expert logic: Bypassing the Standard ParticlesMaterial for 
    # custom GLSL logic (e.g., Flocking, Curl Noise, Swirling).
    _setup_custom_behavior()

func _setup_custom_behavior() -> void:
    var shader_material = ShaderMaterial.new()
    shader_material.shader = load("res://shaders/vfx/vortex_particles.gdshader")
    gpu_particles.process_material = shader_material
    
    # 2. Emission Masks
    # Use a black/white texture to mask particle spawn locations.
    if gpu_particles.process_material is ShaderMaterial:
        gpu_particles.process_material.set_shader_parameter("emission_mask", load("res://assets/vfx/mask.png"))

func toggle_optimization(is_visible: bool) -> void:
    # 3. Visibility-Driven Culling
    # Professional VFX NEVER run when off-screen.
    gpu_particles.emitting = is_visible
    set_process(is_visible)

## EXPERT NOTE:
## Use 'Multi-Pass Material Layers': For complex effects like glowing 
## fire with smoke, use 'Material.next_pass' to render the smoke 
## volume on top of the fire emission in the same system.
## For 'particles', implement 'GPU-Calculated Orbit' logic inside the 
## Shader to move 1,000,000 particles with ZERO CPU cost.
## NEVER use CPUParticles for systems with >500 particles unless 
## targeting low-end mobile/web without Vulkan support.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/creating_a_3d_particle_system.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — ShaderMaterial assignment on GPUParticles process_material
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — visibility-driven emitting/process culling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
