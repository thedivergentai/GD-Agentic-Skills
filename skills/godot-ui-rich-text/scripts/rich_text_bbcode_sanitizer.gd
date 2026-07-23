class_name RichTextBBCodeSanitizer
extends RefCounted

## Expert BBCode Sanitizer.
## Strips potentially malicious or layout-breaking tags from user input.

static func sanitize(input: String, allow_list: Array[String] = ["b", "i", "u", "color"]) -> String:
	var result = input
	var regex = RegEx.new()
	
	# Match any tag starting with [
	regex.compile("\\[/?([a-z0-9_]+)[^\\]]*\\]")
	
	for m in regex.search_all(input):
		var tag_name = m.get_string(1)
		if not allow_list.has(tag_name):
			result = result.replace(m.get_string(), "")
			
	return result
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# - https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md — strip unsafe tags from student/chat input
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — RegEx allow/deny tag filters
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
