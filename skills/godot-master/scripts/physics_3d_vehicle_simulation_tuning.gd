# vehicle_simulation_tuning.gd
# Tuning VehicleBody3D for arcade-style high-speed racing
extends VehicleBody3D

# EXPERT NOTE: VehicleBody3D is a complex Raycast-based sim. 
# Tuning 'Stiffness' and 'Friction' on VehicleWheel3D is 
# more important than engine force for 'feel'.

func apply_drift_physics(active: bool):
	for wheel in get_children():
		if wheel is VehicleWheel3D:
			# Lower friction for drifting
			wheel.wheel_friction_slip = 0.5 if active else 1.0
			# Aggressive steering response
			wheel.steering = Input.get_axis("right", "left") * 0.4
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_vehiclebody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_jolt_physics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md — drift/suspension feel built on VehicleWheel3D knobs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — speed-linked camera FOV for racing
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
