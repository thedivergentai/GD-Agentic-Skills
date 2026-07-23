# skid_mark_emitter.gd
extends Node3D
class_name SkidMarkEmitter

# Tire Smoke and Skid Marks
# Triggers visual effects based on side-slip or drift state.

@export var smoke_particles: GPUParticles3D
@export var threshold := 2.0

func _physics_process(_delta: float) -> void:
    var car = get_parent() as CharacterBody3D
    if not car: return
    
    # Calculate lateral velocity (drifting)
    var side_vel = car.global_transform.basis.x.dot(car.velocity)
    
    # Pattern: Only emit when exceeding a slip threshold to save draw calls.
    if abs(side_vel) > threshold:
        if smoke_particles: smoke_particles.emitting = true
        _place_skid_mark()
    else:
        if smoke_particles: smoke_particles.emitting = false

func _place_skid_mark() -> void:
    # Implementation for spawning Mesh/Trail nodes here.
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/trails.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — trail/smoke gated by slip
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid per-frame skid spawns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
