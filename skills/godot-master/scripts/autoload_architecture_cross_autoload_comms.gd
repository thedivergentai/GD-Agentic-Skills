# cross_autoload_comms.gd
# Rules for Autoload-to-Autoload communication
extends Node

# EXPERT NOTE: Avoid circular dependencies between Autoloads.
# If A needs B and B needs A, your project will likely hang on boot.

func _ready():
	# Use 'await' if checking for a sibling Autoload's node tree
	if not get_tree().root.has_node("SaveManager"):
		await get_tree().process_frame # Give other singletons time to init
		
	_initialize_hooks()

func _initialize_hooks():
	# Connecting to another Singleton safely
	if get_tree().root.has_node("SaveManager"):
		var sm = get_node("/root/SaveManager")
		sm.save_requested.connect(_on_save)

func _on_save():
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — connect after peer Autoloads exist
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — typical SaveManager hook target
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — diagnose null peer at boot
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
