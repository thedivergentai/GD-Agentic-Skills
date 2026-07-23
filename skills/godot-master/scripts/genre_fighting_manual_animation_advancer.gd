# manual_animation_advancer.gd
# Syncing animations strictly to physics/rollback frames
extends AnimationMixer

# EXPERT NOTE: For determinism, stop child AnimationPlayers 
# and manually call advance() inside _physics_process().

func _ready():
	callback_mode_process = ANIMATION_CALLBACK_MODE_PROCESS_MANUAL

func step_animation(delta: float):
	# Advancing by fixed delta to ensure frame-sync with logic
	advance(delta)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationmixer.html
# - https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — ADVANCE_MANUAL hit windows
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
