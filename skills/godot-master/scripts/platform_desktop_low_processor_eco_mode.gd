class_name LowProcessorEcoMode
extends Node

## Expert Eco Mode/Low Processor usage optimization.
## Ideal for desktop utilities, launchers, or laptop-friendly settings.

func set_eco_mode(enabled: bool) -> void:
	# Only redraw if something changes (animations, input)
	OS.low_processor_usage_mode = enabled
	
	if enabled:
		# Increase sleep time between frames to reduce CPU heat
		OS.low_processor_usage_mode_sleep_usec = 8000
	else:
		OS.low_processor_usage_mode_sleep_usec = 6900 # Default

## Tip: This can reduce GPU power draw by up to 90% in idle/static UI apps.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/creating_applications.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — idle-friendly launchers/tools
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — when eco mode is not enough
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
