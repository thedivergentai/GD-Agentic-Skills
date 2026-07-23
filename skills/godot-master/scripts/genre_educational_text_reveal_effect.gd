# text_reveal_effect.gd
# Custom RichTextEffect for engaging content reveals
@tool
extends RichTextEffect
class_name RichTextWobble

# EXPERT NOTE: Custom effects allow for 'game-ifying' 
# educational text reading for younger users.

var bbcode = "wobble"

func _process_custom_fx(char_fx):
	var speed = char_fx.env.get("speed", 5.0)
	var freq = char_fx.env.get("freq", 2.0)
	char_fx.offset.y += sin(char_fx.elapsed_time * speed + char_fx.relative_index * freq) * 2.0
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# - https://docs.godotengine.org/en/stable/classes/class_richtexteffect.html
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — custom BBCode effect registration
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — alternate non-shader reveal timing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — pair reveals with reward VFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
