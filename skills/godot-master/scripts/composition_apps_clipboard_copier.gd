# clipboard_copier.gd
class_name ClipboardCopier
extends Node

signal copy_success
signal copy_failed(reason: String)

func copy_text(text: String) -> void:
	if text.is_empty():
		copy_failed.emit("Text empty")
		return
	DisplayServer.clipboard_set(text)
	copy_success.emit()
