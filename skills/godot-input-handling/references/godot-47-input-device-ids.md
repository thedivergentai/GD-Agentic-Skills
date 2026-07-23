# Godot 4.7: Input Device IDs

- Mouse and keyboard are no longer device ID `0` â€” use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD`.
- **NEVER** compare `event.device == 0` for mouse/keyboard; joypads may legitimately use ID 0.
