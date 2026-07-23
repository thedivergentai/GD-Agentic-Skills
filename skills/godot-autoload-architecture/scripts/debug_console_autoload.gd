# debug_console_autoload.gd
# Universal debug overlay accessible from any scene
extends CanvasLayer

# EXPERT NOTE: UI Autoloads should use CanvasLayer to ensure they 
# always draw on top of game scenes.

@onready var label = $Label

func _ready():
	process_mode = PROCESS_MODE_ALWAYS # Console works even when paused

func log_message(msg: String):
	label.text += "\n" + msg
	print("[Debug] ", msg)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html
# - https://docs.godotengine.org/en/stable/classes/class_canvaslayer.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — in-game console overlay workflows
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — layout for always-on debug HUD
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — toggle key while tree paused
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
