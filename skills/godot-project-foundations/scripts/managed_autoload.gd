## Managed Autoload Pattern
## Use this as a foundation for singletons that delegate logic to RefCounted classes.
## This prevents "Monolithic Singleton" bloat by keeping the Node skeleton light.
extends Node

# Use static variables for globally shared data without instance overhead checks
static var run_id: int = 0
static var session_start_time: float = 0.0

# Delegation: Systems are RefCounted classes, NOT nodes, to keep the Tree clean
var economy_system: RefCounted
var achievement_system: RefCounted

func _enter_tree() -> void:
	# Autoloads should strictly manage business logic; avoid UI/Visual references.
	process_mode = Node.PROCESS_MODE_ALWAYS
	session_start_time = Time.get_unix_time_from_system()
	_initialize_subsystems()

func _initialize_subsystems() -> void:
	# Dependency Injection style initialization
	# economy_system = EconomyEngine.new()
	pass

static func get_uptime() -> float:
	return Time.get_unix_time_from_system() - session_start_time
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — boot order and RefCounted delegation patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — keep Autoload APIs signal-light when possible
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
