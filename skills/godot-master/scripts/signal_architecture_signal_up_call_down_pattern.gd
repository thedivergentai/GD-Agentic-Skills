# signal_up_call_down_pattern.gd
# Decoupling logic by restricting how nodes interact
extends Node

# EXPERT NOTE: "Signal Up" means children emit events. 
# "Call Down" means parents call child methods. 
# NEVER have a child call get_parent().method().

# --- CHILD SCRIPT Example (Player.gd) ---
# signal action_completed

# --- PARENT SCRIPT (Level.gd) ---
@onready var player = $Player

func _ready():
	# Parent calls down to initialize
	player.initialize_stats(100)
	# Parent listens to child events
	player.action_completed.connect(_on_player_action_completed)

func _on_player_action_completed():
	print("Player finished task. Level progressing.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — parent owns wiring; children only emit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — keep call-down paths valid across scene swaps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
