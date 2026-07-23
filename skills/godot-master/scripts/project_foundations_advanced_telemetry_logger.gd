## Advanced Telemetry Logger
## Intercepts engine print/error streams and routes them to a custom sink.
## Mandatory for production build crash reporting and remote diagnostics.
extends Node

# Implementation of a custom Logger requires inheritance and OS registration
class TelemetrySink extends Logger:
	var _log_mutex := Mutex.new()
	var _session_log: Array[String] = []

	func _log_error(message: String) -> void:
		_process_log(message, true)

	func _log_message(message: String, _level: int = 0) -> void:
		_process_log(message, false)

	func _process_log(message: String, is_error: bool) -> void:
		# Multi-threaded safety is CRITICAL for Loggers
		_log_mutex.lock()
		var entry = "[%s] %s: %s" % [
			Time.get_time_string_from_system(),
			"ERROR" if is_error else "LOG",
			message
		]
		_session_log.append(entry)
		# Expert: Route to remote telemetry server or secure local encrypted file here
		# Do NOT use print() here; it causes infinite recursion.
		_log_mutex.unlock()

func _enter_tree() -> void:
	# Register the sink into the OS to capture ALL engine output
	# This should be done as early as possible in the project lifecycle.
	OS.add_logger(TelemetrySink.new())
	print("Foundations: Telemetry System Online.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_logger.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/classes/class_mutex.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — production sinks pair with editor profilers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — release builds need crash/telemetry hooks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
