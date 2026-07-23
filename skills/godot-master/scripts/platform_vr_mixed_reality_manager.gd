class_name MixedRealityManager extends Node
## Switches the headset to AR/Passthrough mode.

func switch_to_ar() -> void:
    var xr_interface := XRServer.primary_interface
    if xr_interface and XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in xr_interface.get_supported_environment_blend_modes():
        xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
        # Required for the camera feed to show through transparent areas.
        get_viewport().transparent_bg = true
