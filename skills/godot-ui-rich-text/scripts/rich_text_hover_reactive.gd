class_name RichTextHoverReactive
extends RichTextLabel

## Expert Mouse-Reactive Text Spans.
## Triggers sound and cursor changes when hovering over [url].

@export var hover_sfx: AudioStream

func _ready() -> void:
	meta_hover_started.connect(_on_hover_in)
	meta_hover_ended.connect(_on_hover_out)

func _on_hover_in(_meta: Variant) -> void:
	if hover_sfx:
		var p := AudioStreamPlayer.new()
		p.stream = hover_sfx
		add_child(p)
		p.play()
		p.finished.connect(p.queue_free)
	
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_hover_out(_meta: Variant) -> void:
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — cursor/SFX on meta hover without focus fights
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — hover started/ended as thin UI signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
