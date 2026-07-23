# interactive_music_graph.gd
# Expert pattern for non-linear, interactive music scoring.
# Grounded in Godot 4.x AudioStreamInteractive (available in 4.3+).

extends AudioStreamPlayer

class_name InteractiveMusicGraph

## Logic for transitioning between music states (e.g., Exploration to Combat).
func transition_to_state(state_name: String) -> void:
	if stream is AudioStreamInteractive:
		var interactive_stream := stream as AudioStreamInteractive
		# Find the clip index by name
		# In Godot 4.3+, you'd use the AudioStreamInteractive API directly.
		print("Interactive Music: Transitioning to '%s'" % state_name)
		# Placeholder for actual transition logic
	else:
		push_warning("Interactive Music: Stream is not an AudioStreamInteractive.")

## Expert Tip: Use 'switch_mode' (Beat, Bar, Transition) to ensure 
## musical continuity when changing states.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_audiostreaminteractive.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplaybackinteractive.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — clip graph mirrors game FSM
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — trigger explore→combat switches
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md — Beat/Bar switch_mode alignment
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
