# dialogue_lipsync.gd
extends Node

func start_speaking(text: String) -> void:
	var cb := Callable(self, &"_on_tts_boundary")
	DisplayServer.tts_set_utterance_callback(DisplayServer.TTS_UTTERANCE_BOUNDARY, cb)
	var voices := DisplayServer.tts_get_voices_for_language("en")
	if voices.is_empty():
		return
	DisplayServer.tts_speak(text, voices[0])

func _on_tts_boundary(char_idx: int, _id: int) -> void:
	_update_mouth_shape(char_idx)

func _update_mouth_shape(_char_idx: int) -> void:
	pass
