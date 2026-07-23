class_name HeroNetSync extends CharacterBody3D

func _ready() -> void:
    # Enable native engine interpolation for visual smoothness
    physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
    
    if is_multiplayer_authority():
        setup_synchronizer()

func setup_synchronizer() -> void:
    var sync := $MultiplayerSynchronizer
    var config := SceneReplicationConfig.new()
    # Sync position/rotation via unreliable ordered packets
    config.add_property(NodePath(".:global_position"))
    sync.replication_config = config
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
