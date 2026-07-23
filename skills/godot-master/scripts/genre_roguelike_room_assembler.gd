# room_assembler.gd
func add_room(new_scene: PackedScene, prev_exit: Marker2D):
    var inst = new_scene.instantiate()
    add_child(inst)
    await inst.tree_entered # Wait for node to be ready
    
    var entrance = inst.get_node("Entrance")
    # Snap room so entrance matches previous exit
    var offset = inst.global_position - entrance.global_position
    inst.global_position = prev_exit.global_position + offset
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
