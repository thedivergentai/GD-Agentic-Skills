class_name NativeShellExecutor
extends Node

## Expert native shell integration via OS.execute_with_pipe.
## Allows running CLI tools and capturing their output for editor integrations.

func run_shell_command(command: String, args: PackedStringArray) -> String:
	var output = []
	var err = OS.execute(command, args, output, true)
	if err == OK:
		return "".join(output)
	return "Error: " + str(err)

## Warning: Use caution with shell execution to avoid security vulnerabilities.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — editor/tool shell integrations
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — platform path/security constraints
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
