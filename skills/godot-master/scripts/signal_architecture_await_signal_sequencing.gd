# await_signal_sequencing.gd
# Replacing timers and flag-based logic with awaits
extends Node

func start_boss_intro():
	print("Boss Roar!")
	# Create and await an inline timer
	await get_tree().create_timer(2.0).timeout
	
	$Boss/AnimationPlayer.play("camera_pan")
	# Wait for animation to finish signal
	await $Boss/AnimationPlayer.animation_finished
	
	print("Battle Start!")
	$UI/BossBar.show()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — await animation_finished in intros
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — linear await vs timer flag soup
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
