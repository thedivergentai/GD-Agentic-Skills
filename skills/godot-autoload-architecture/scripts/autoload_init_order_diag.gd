# autoload_init_order_diag.gd
# Checking Autoload initialization sequence
extends Node

# EXPERT NOTE: Autoloads initialize in the order they appear in 
# Project Settings -> AutoLoad. Use this for dependency debugging.

func _ready():
	print("[AutoLoad Diagnostic] Initialized: ", name)
	
	# Check for dependencies. If 'GlobalConfig' must be first:
	if not get_tree().root.has_node("GlobalConfig"):
		push_error("CRITICAL: GlobalConfig Autoload missing or loaded after %s!" % name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — escalate boot-order hangs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — Project Settings Autoload list
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — assert dependency order in CI
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
