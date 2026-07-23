# Multi-Modal Input & UI Glyphs

Modern games must handle simultaneous Controller and Keyboard/Mouse input smoothly.

### 1. Handling Input Modes
- **Mouse Aiming**: Process `InputEventMouseMotion` in `_unhandled_input()` for relative movement.
- **Stick Movement**: Poll `Input.get_vector()` in `_physics_process()` for clamped state.

### 2. Dynamic Glyph Swapping
To update UI prompts (e.g., "Press E" vs "Press X") in real-time:
- **Autoload Strategy**: Create a singleton that monitors `_input(event)`.
- **Detection**: Check `event is InputEventJoypadButton` or `InputEventJoypadMotion` to detect gamepad use.
- **Broadcasting**: Emit a signal (e.g., `signal device_changed(is_gamepad: bool)`) when the hardware type shifts. All UI elements should listen to this signal to swap their prompt textures.
