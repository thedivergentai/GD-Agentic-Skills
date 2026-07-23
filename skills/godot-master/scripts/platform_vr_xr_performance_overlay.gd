class_name XRPerformanceOverlay extends OpenXRCompositionLayerQuad
## A crisp UI overlay projected directly by the XR runtime.

@export var sub_viewport: SubViewport

func _ready() -> void:
    # Assign the viewport to the composition layer.
    layer_viewport = sub_viewport
    alpha_blend = true
    # Position in front of the user (relative to XROrigin3D).
    position = Vector3(0.0, 1.5, -1.0)
