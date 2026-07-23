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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — encrypted_pass meta stats protection
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — subtle +5–15% meta buffs vs grind-to-win
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
