# packet_peer_latency_test.gd
# Measuring ping and network jitter
extends Node

var last_ping_time: int = 0

func _process(_delta):
	if Time.get_ticks_msec() - last_ping_time > 1000:
		check_ping.rpc()
		last_ping_time = Time.get_ticks_msec()

@rpc("any_peer", "call_remote", "unreliable")
func check_ping():
	if multiplayer.is_server():
		return_ping.rpc_id(multiplayer.get_remote_sender_id(), Time.get_ticks_msec())

@rpc("authority", "call_remote", "unreliable")
func return_ping(server_time: int):
	var latency = Time.get_ticks_msec() - server_time
	print("Latency: ", latency, "ms")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_packetpeerudp.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — latency/jitter test harness
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — multi-instance ping tests
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
