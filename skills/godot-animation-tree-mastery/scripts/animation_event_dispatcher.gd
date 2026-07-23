class_name AnimationEventDispatcher extends Node

signal animation_event(event_name: String, metadata: Variant)

## Generic function called by AnimationPlayer Method Tracks
func dispatch_event(event_name: String, metadata: Variant) -> void:
    animation_event.emit(event_name, metadata)

# Workflow:
# 1. Add Method Track to animation (e.g., "walk")
# 2. Keyframe: method="dispatch_event", args=["footstep", "stone"]
# 3. Audio manager listens to signal and plays correct 'stone' SFX.
