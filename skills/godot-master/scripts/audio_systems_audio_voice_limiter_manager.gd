class_name AudioVoiceLimiterManager
extends Node

## Expert SFX instance limiter.
## Prevents 'Phasing' and 'Ear Bleed' by capping identical sound instances.

var active_counts: Dictionary = {}

func can_play(sound_id: String, limit: int = 5) -> bool:
	var count = active_counts.get(sound_id, 0)
	if count >= limit:
		return false
	
	active_counts[sound_id] = count + 1
	# Logic to decrement count when sound finishes...
	return true

## Rule: Limit weapons/explosions to 5-10 concurrent instances to maintain clarity.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_audioeffecthardlimiter.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — concurrent SFX caps vs perceived power
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — explosion/gunshot spam sources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — fewer voices = cheaper mix
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
