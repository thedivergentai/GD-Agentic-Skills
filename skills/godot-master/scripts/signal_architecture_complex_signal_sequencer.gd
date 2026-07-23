# complex_signal_sequencer.gd
# Managing multi-step async sequences using signals
extends Node

func run_intro():
	# Chain of awaits for a clean linear flow
	await $Fade.fade_out()
	await get_tree().process_frame # Ensure UI is updated
	
	$LevelLoader.load_map("Level1")
	await $LevelLoader.finished
	
	await $Fade.fade_in()
	$Player.enable()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — await loader.finished before enabling player
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — fade await chains beside signal awaits
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
