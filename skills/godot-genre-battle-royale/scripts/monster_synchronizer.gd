# monster_synchronizer.gd
class_name MonsterSynchronizer extends Node

func setup_replication(monster: CharacterBody3D) -> void:
    var sync := MultiplayerSynchronizer.new()
    add_child(sync)
    
    var config := SceneReplicationConfig.new()
    
    # Position: High frequency sync
    var pos_path := NodePath(str(monster.get_path()) + ":position")
    config.add_property(pos_path)
    config.property_set_replication_mode(pos_path, SceneReplicationConfig.REPLICATION_MODE_ALWAYS)
    
    # Health: Delta-patch (only sync when changed)
    var health_path := NodePath(str(monster.get_path()) + ":current_health")
    config.add_property(health_path)
    config.property_set_replication_mode(health_path, SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
    
    sync.replication_config = config
    sync.delta_interval = 0.05 # Limit sync to 20Hz for bandwidth efficiency
