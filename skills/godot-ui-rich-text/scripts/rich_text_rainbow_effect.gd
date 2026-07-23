@tool
class_name RichTextRainbowEffect
extends RichTextEffect

## Expert Rainbow Text Effect.
## Syntax: [rainbow_fx freq=5.0 sat=0.8 val=0.8]Text[/rainbow_fx]

var bbcode := "rainbow_fx"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var freq: float = char_fx.env.get("freq", 5.0)
	var sat: float = char_fx.env.get("sat", 0.8)
	var val: float = char_fx.env.get("val", 0.8)
	
	# Calculate hue based on time and character index
	var hue: float = wrapf(char_fx.elapsed_time * freq + (char_fx.relative_index * 0.1), 0.0, 1.0)
	char_fx.color = Color.from_hsv(hue, sat, val, char_fx.color.a)
	
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_richtexteffect.html
# - https://docs.godotengine.org/en/stable/classes/class_charfxtransform.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — escalate beyond CharFX when panel-wide FX needed
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — register custom tags in dialogue lines
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
