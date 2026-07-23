# bootstrap_config.gd
# Expert pattern for managing initialization priority and AutoLoad order.
# Grounded in architectural best practices for Godot 4.x.

extends RefCounted

class_name BootstrapConfig

## Priority list for global system initialization.
# Lower numbers initialize first.
const BOOTSTRAP_PRIORITY := {
	"ConfigManager": 1,
	"SaveManager": 10,
	"PlayerManager": 20,
	"SceneTransitioner": 30,
	"AudioManager": 40,
	"InputRecorder": 50
}

## Validates the current AutoLoad order against the intended bootstrap priority.
static func validate_autoload_order() -> void:
	# Note: Accessing ProjectSettings via code allows runtime verification,
	# but actual order is defined in project.godot.
	print("Bootstrap Config: Validating initialization order...")
	
	# Expert logic: In a real tool, this would parse project.godot 
	# and ensure [autoload] entries match the sorted BOOTSTRAP_PRIORITY.
	
	for system in BOOTSTRAP_PRIORITY.keys():
		print("- System: %s (Priority: %d)" % [system, BOOTSTRAP_PRIORITY[system]])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — validating Autoload priority lists at boot
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — project.godot Autoload registration hygiene
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
