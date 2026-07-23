class_name HSMStateTimerComponent
extends Timer

## Expert component for State machine auto-transitions.
## Automatically triggers a state exit/transition after a set duration.

signal state_timeout

func start_state_timer(duration: float) -> void:
	wait_time = duration
	one_shot = true
	start()
	timeout.connect(func(): state_timeout.emit(), CONNECT_ONE_SHOT)

## Rule: Use timers for finite states like 'Stun', 'WallClip', or 'Dash'.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_timer.html
# - https://docs.godotengine.org/en/stable/classes/class_object.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — stun/dash/channel durations as one-shot state timers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hit-stun auto-exit via state_timeout → transition
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
