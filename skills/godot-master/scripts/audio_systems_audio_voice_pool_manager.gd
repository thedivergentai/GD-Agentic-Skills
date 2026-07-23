class_name AudioVoicePoolManager
extends Node

## Expert Voice Pool Manager.
## Prioritizes hero sounds and steals the oldest lowest-priority background voice.

const MAX_VOICES := 32
const PRIORITY_BACKGROUND := 0
const PRIORITY_STANDARD := 1
const PRIORITY_HERO := 2

var pool: Array[AudioStreamPlayer] = []
## Parallel priority for each pool slot (same index as `pool`).
var priorities: PackedInt32Array = PackedInt32Array()
## Parallel start time (msec) for age-based steal among equal priority.
var started_msec: PackedInt64Array = PackedInt64Array()

func _ready() -> void:
	priorities.resize(MAX_VOICES)
	started_msec.resize(MAX_VOICES)
	for i in range(MAX_VOICES):
		var p := AudioStreamPlayer.new()
		add_child(p)
		pool.append(p)
		priorities[i] = PRIORITY_BACKGROUND
		started_msec[i] = 0
		p.finished.connect(_on_voice_finished.bind(i))

func play_sound(stream: AudioStream, priority: int = PRIORITY_STANDARD, bus: StringName = &"SFX") -> AudioStreamPlayer:
	# priority: 0 = background, 1 = standard, 2 = hero (never stolen)
	if stream == null:
		return null
	var idx := _find_idle_index()
	if idx < 0:
		idx = _steal_voice_index(priority)
	if idx < 0:
		return null
	var player := pool[idx]
	player.stream = stream
	player.bus = String(bus)
	priorities[idx] = clampi(priority, PRIORITY_BACKGROUND, PRIORITY_HERO)
	started_msec[idx] = Time.get_ticks_msec()
	player.play()
	return player

func _find_idle_index() -> int:
	for i in range(pool.size()):
		if not pool[i].playing:
			return i
	return -1

func _steal_voice_index(incoming_priority: int) -> int:
	## Steal oldest among non-hero voices with priority strictly below incoming.
	## If none, steal oldest non-hero with priority <= incoming (except equal-hero).
	var best_idx := -1
	var best_pri := 999
	var best_age := -1
	var now := Time.get_ticks_msec()
	for i in range(pool.size()):
		var pri := int(priorities[i])
		if pri >= PRIORITY_HERO:
			continue  # never kill hero
		if pri > incoming_priority:
			continue  # never steal higher than incoming
		var age := int(now - started_msec[i])
		if pri < best_pri or (pri == best_pri and age > best_age):
			best_pri = pri
			best_age = age
			best_idx = i
	if best_idx >= 0:
		pool[best_idx].stop()
	return best_idx

func _on_voice_finished(idx: int) -> void:
	priorities[idx] = PRIORITY_BACKGROUND
	started_msec[idx] = 0

## Rule: Never exceed MAX_VOICES to avoid audio engine stutter/latency.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_audiostreampolyphonic.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — escalate when pool size still burns mix CPU
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune steal priority vs gameplay clarity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — typical Autoload home for the pool
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md
# =============================================================================
