class_name ConsoleShaderManager extends Node
## Manages GPU-specific shader binary compilation.

func get_device_uuid() -> String:
    var rd := RenderingServer.get_rendering_device()
    if rd:
        # Unique ID for the specific GPU and Driver.
        return rd.get_device_pipeline_cache_uuid()
    return ""
