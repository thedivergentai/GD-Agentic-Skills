extends Resource
class_name MetaStatsResource

## Expert Meta-Progression (Godot 4.7).
## Encrypted persistent stats for cross-run upgrades.

@export var max_health_bonus: int = 0
@export var attack_multiplier: float = 1.0
@export var unlocked_classes: Array[String] = []

const SAVE_PATH = "user://meta_progression.cfg"
const CRYPTO_KEY = "expert_godot_roguelike_key"

func save_stats() -> void:
	var config = ConfigFile.new()
	config.set_value("Meta", "health", max_health_bonus)
	config.set_value("Meta", "attack", attack_multiplier)
	# Expert Pattern: Save encrypted to prevent user tampering
	config.save_encrypted_pass(SAVE_PATH, CRYPTO_KEY)

func load_stats() -> void:
	var config = ConfigFile.new()
	if config.load_encrypted_pass(SAVE_PATH, CRYPTO_KEY) == OK:
		max_health_bonus = config.get_value("Meta", "health", 0)
		attack_multiplier = config.get_value("Meta", "attack", 1.0)

## [SKILL NOTICE]: Always save meta-progression to 'user://' using 
## 'save_encrypted_pass()' to protect the game's economy from easy cheats.
