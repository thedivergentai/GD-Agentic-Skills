# input_judge_logic.gd
extends Node
class_name InputJudgeLogic

# Window-Based Hit Validation
# Compares input timing against target beat time with specific windows.

@export var window_perfect := 0.05 # 50ms
@export var window_good := 0.1     # 100ms
@export var window_ok := 0.15      # 150ms

enum HitResult { NONE, PERFECT, GOOD, OK, MISS }

func judge_hit(current_time: float, target_time: float) -> HitResult:
    var diff = abs(current_time - target_time)
    
    # Pattern: Sequential window checks from smallest to largest.
    if diff <= window_perfect: return HitResult.PERFECT
    if diff <= window_good: return HitResult.GOOD
    if diff <= window_ok: return HitResult.OK
    return HitResult.MISS
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — lane press events vs process polling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune Perfect/Good window widths
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — song-time base for judgment diffs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md
# =============================================================================
