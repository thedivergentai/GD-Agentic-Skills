# safe_dynamic_connections.gd
# Verifying connection state to prevent runtime errors
extends Node

func connect_sensor(sensor: Node):
	var callback = _on_sensor_triggered
	
	# Connecting a connected signal is a runtime error.
	if not sensor.triggered.is_connected(callback):
		sensor.triggered.connect(callback)

func _on_sensor_triggered():
	print("Sensor activity detected.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# - https://docs.godotengine.org/en/stable/classes/class_object.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — is_connected before reconnect
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — assert single connection in tests
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
