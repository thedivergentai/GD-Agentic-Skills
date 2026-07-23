class_name RTSMassiveUnitRenderer extends MultiMeshInstance3D

@export var max_units: int = 10000
@export var unit_mesh: Mesh

func _ready() -> void:
    multimesh = MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.use_colors = true 
    multimesh.instance_count = max_units
    multimesh.mesh = unit_mesh
    multimesh.visible_instance_count = 0

## Sync logical unit transforms to GPU instances
func synchronize_rendering(active_units: Array[Transform3D]) -> void:
    var count: int = min(active_units.size(), max_units)
    multimesh.visible_instance_count = count
    
    for i in range(count):
        multimesh.set_instance_transform(i, active_units[i])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
