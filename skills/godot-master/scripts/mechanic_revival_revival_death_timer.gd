class_name RevivalDeathTimer
extends Timer

## Expert Respawn Timer.
## Manages transition duration and UI callbacks for game-over screens.

@export var respawn_time: float = 3.0

func start_death_timer() -> void:
	wait_time = respawn_time
	one_shot = true
	start()
	# Trigger UI 'YOU DIED' here
	timeout.connect(_on_timeout)

func _on_timeout() -> void:
	RevivalGlobalManager.trigger_death()

## Tip: Use 'one_shot' timers for death logic to avoid recursive respawns if dying during the timer.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_timer.html — one_shot death→respawn delay
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — alternate SceneTreeTimer delay pattern
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — timeout → UI YOU DIED → global respawn
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — death screen layout during wait
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
