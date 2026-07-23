# await_sequence_manager.gd
# Pausing execution flow using await without blocking threads
extends Node

func play_intro_sequence():
	print("Step 1: Fade In")
	# Suspend until a signal is received
	await get_tree().create_timer(1.0).timeout
	
	print("Step 2: Spawn Player")
	# Suspend until next physics frame
	await get_tree().physics_frame
	
	print("Step 3: Enable UI")
	await _ui_animation_done()
	print("Sequence Complete")

func _ui_animation_done():
	# Example of a function returning a signal to be awaited
	return get_tree().create_timer(0.5).timeout
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — await loaders before enabling gameplay
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — await signal chains vs timer flag soup
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
