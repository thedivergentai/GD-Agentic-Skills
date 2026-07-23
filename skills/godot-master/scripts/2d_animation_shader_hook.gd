# skills/2d-animation/code/shader_hook.gd
extends Sprite2D

## Shader Parameter Hooks Expert Pattern
## Demonstrates animating ShaderMaterial uniforms directly via AnimationPlayer.

# 1. Ensure the Sprite2D has a ShaderMaterial assigned.
# 2. In AnimationPlayer, add a track of type 'Property Track'.
# 3. Path: "material:shader_parameter/line_thickness" (as an example).

@onready var anim_player: AnimationPlayer = $AnimationPlayer

## Example uniform names:
## 'line_thickness' for outline shaders
## 'dissolve_value' for teleport/death effects
## 'hit_flash' for damage feedback

func trigger_damage_flash() -> void:
    # Programmatic trigger if needed, but best practice is to have 
    # a dedicated 'Damage' animation that handles this visually.
    anim_player.play("HitFlash")

func trigger_teleport_out() -> void:
    # Using await to ensure gameplay waits for the visual effect
    anim_player.play("Dissolve")
    await anim_player.animation_finished
    # Logic to remove character or move position
    # queue_free() # or hide()

## EXPERT NOTE: 
## If you need to animate parameters on many instances (like grass blowing), 
## use 'Instance Uniforms' in Godot 4.0+ to avoid creating unique material 
## resources for every sprite, which saves significant memory/draw calls.
## Path for animation: "instance_shader_parameters/parameter_name"
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_2d_shader.html
# - https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — CanvasItem uniforms and dissolve/flash patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — property tracks on material:shader_parameter/*
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md
# =============================================================================
