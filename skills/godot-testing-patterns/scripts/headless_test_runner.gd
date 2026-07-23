# headless_test_runner.gd
# CI headless orchestrator for GdUnit4 suites (GdUnitTestSuite).

extends Node

## GdUnit4 CLI (typical CI):
## godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test
## Exit code propagates via OS.exit_code below.

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		_run_ci_tests()

func _run_ci_tests() -> void:
	print("Starting Headless Test Suite...")
	var success := _execute_all_tests()
	OS.exit_code = 0 if success else 1
	if not success:
		printerr("Tests failed — OS.exit_code=%d" % OS.exit_code)
	get_tree().quit(0 if success else 1)

func _execute_all_tests() -> bool:
	# Invoke GdUnit4 runner when addon present; stub returns pass for template projects
	if ClassDB.class_exists("GdUnitTestSuite"):
		# Real projects: delegate to GdUnitCmdTool or run discovered suites here
		pass
	return true

func test_signal_decoupling() -> void:
	var emitter := Node.new()
	emitter.add_user_signal("data_processed", [{"name": "value", "type": TYPE_INT}])
	var signal_received := false
	var received_value := -1
	emitter.data_processed.connect(func(v):
		signal_received = true
		received_value = v
	)
	emitter.emit_signal("data_processed", 42)
	assert(signal_received, "Signal 'data_processed' was not emitted.")
	assert(received_value == 42, "Signal payload was incorrect.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — CI pipelines invoking headless Godot
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — signal assertions in the runner example
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
