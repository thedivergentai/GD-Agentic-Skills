# note_object_pool.gd
extends Node
class_name NoteObjectPool

# High-Frequency Entity Recycling
# Pre-instantiates notes to avoid frame drops during busy sequences.

@export var note_scene: PackedScene
@export var pool_size := 50
var _pool: Array[Node] = []

func _ready() -> void:
    for i in pool_size:
        var note = note_scene.instantiate()
        note.hide()
        note.process_mode = PROCESS_MODE_DISABLED
        add_child(note)
        _pool.append(note)

func get_note() -> Node:
    # Pattern: Fetch disabled nodes from the pool and reactive them.
    for note in _pool:
        if not note.visible:
            note.show()
            note.process_mode = PROCESS_MODE_INHERIT
            return note
    return null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — escalate when pool size still hitchs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — PackedScene note templates
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — shared pool Autoload lifetime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
