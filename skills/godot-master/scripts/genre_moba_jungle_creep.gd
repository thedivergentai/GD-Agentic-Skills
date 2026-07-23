class_name JungleCreep extends CharacterBody3D

@export var leash_radius: float = 12.0
@onready var spawn_pos := global_position

func _physics_process(_delta: float) -> void:
    var dist_from_home := global_position.distance_to(spawn_pos)
    
    match state:
        State.CHASING:
            if dist_from_home > leash_radius:
                state = State.LEASHING
        State.LEASHING:
            # Move back to spawn_pos using NavigationAgent3D
            nav_agent.target_position = spawn_pos
            if global_position.distance_to(spawn_pos) < 1.0:
                state = State.IDLE
                health = max_health # Reset health on return
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
