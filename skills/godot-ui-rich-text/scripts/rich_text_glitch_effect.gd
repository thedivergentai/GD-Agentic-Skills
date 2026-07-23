@tool
class_name RichTextGlitchEffect
extends RichTextEffect

## Expert Glitch/Horror Text Effect.
## Syntax: [glitch_fx level=2.0]Scary Text[/glitch_fx]

var bbcode := "glitch_fx"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var intensity: float = char_fx.env.get("level", 2.0)
	
	# High-frequency jitter
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(char_fx.relative_index + int(char_fx.elapsed_time * 15.0))
	
	char_fx.offset = Vector2(
		rng.randf_range(-intensity, intensity),
		rng.randf_range(-intensity, intensity)
	)
	
	# Random flickering
	if rng.randf() > 0.8:
		char_fx.color.a *= 0.3
		
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_richtexteffect.html
# - https://docs.godotengine.org/en/stable/classes/class_charfxtransform.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — screen-space glitch when glyph jitter is not enough
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md — horror VN line presentation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
