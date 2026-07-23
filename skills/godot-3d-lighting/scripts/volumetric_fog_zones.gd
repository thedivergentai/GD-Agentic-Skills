# Volumetric Fog Transition Zones
extends FogVolume

## Smoothly transitioning fog density as the player enters a localized area
## like a cave or a dense forest patch.

func _on_body_entered(body: Node3D) -> void:
    if body is CharacterBody3D:
        var tween = create_tween()
        # Fade density from global environment value to local volume value
        tween.tween_property(self, "density", 1.5, 2.0)

func _on_body_exited(body: Node3D) -> void:
    if body is CharacterBody3D:
        var tween = create_tween()
        tween.tween_property(self, "density", 0.0, 1.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html
# - https://docs.godotengine.org/en/stable/classes/class_fogvolume.html
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — Area3D enter/exit for fog zones
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — density blend duration
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — camera env during zone blends
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
