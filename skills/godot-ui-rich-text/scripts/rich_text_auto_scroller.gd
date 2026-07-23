class_name RichTextAutoScroller
extends RichTextLabel

## Expert Vertical Auto-Scroll (Credits/Logs).
## Automatically advances the scroll bar smoothly.

@export var scroll_speed: float = 30.0 # Pixels per second
@export var pause_on_hover: bool = true

func _process(delta: float) -> void:
	if pause_on_hover and get_global_rect().has_point(get_global_mouse_position()):
		return
		
	var v_scroll = get_v_scroll_bar()
	v_scroll.value += scroll_speed * delta
	
	if v_scroll.value >= v_scroll.max_value - v_scroll.page:
		# Optionally loop or stop
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# - https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — smooth scroll polish without per-frame BBCode rebuild
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — ScrollContainer vs RichTextLabel internal scroll
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
