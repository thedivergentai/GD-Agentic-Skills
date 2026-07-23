class_name EasterEggCollectionTracker
extends Node

## Expert collection registry for hidden event items.
## Tracks total eggs found and emits signals for HUD updates.

signal egg_count_changed(found: int, total: int)
signal all_eggs_found

var total_eggs := 0
var found_eggs := 0

func register_egg() -> void:
	total_eggs += 1
	egg_count_changed.emit(found_eggs, total_eggs)

func collect_egg() -> void:
	found_eggs += 1
	egg_count_changed.emit(found_eggs, total_eggs)
	
	if found_eggs >= total_eggs:
		all_eggs_found.emit()

## Tip: Use a Global Autoload for this tracker to persist counts across scene changes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — base Theme architecture
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — confetti/shimmer VFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md
# =============================================================================
