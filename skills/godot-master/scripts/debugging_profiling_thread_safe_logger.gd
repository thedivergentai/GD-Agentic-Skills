# thread_safe_logger.gd
# Writing custom log files without blocking the main thread
class_name ThreadSafeLogger extends Logger

var _mutex := Mutex.new()
var _log_file: FileAccess

# EXPERT NOTE: Subclassing Logger and using a Mutex ensures 
# that logs from worker threads don't corrupt the file stream.

func _log_message(message: String, _error: bool):
	_mutex.lock()
	# Real implementations would write to _log_file here
	_mutex.unlock()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html
# - https://docs.godotengine.org/en/stable/classes/class_logger.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — register custom Logger Autoload
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — worker-thread log sinks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
