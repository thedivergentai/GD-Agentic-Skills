# ability_ui_binder.gd
extends Control
class_name AbilityUIBinder

# Decoupled UI Cooldown Tracking
# Binds UI elements to hero signals to keep visual logic separate from combat.

func _ready() -> void:
    # Pattern: Find local player hero in a predictable group.
    var hero: Node = get_tree().get_first_node_in_group(&"local_player")
    if hero and hero.has_signal(&"ability_cast"):
        # Bind identity metadata to the callback for modularity.
        hero.ability_cast.connect(_on_ability_cast.bind(0)) # Bind index 0 for Q

func _on_ability_cast(cooldown_remaining: float, ability_index: int) -> void:
    # Logic to update cooldown radial progress bars.
    print("Ability ", ability_index, " cooldown started: ", cooldown_remaining)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — ability_cast bus wiring
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — cooldown UI contracts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
