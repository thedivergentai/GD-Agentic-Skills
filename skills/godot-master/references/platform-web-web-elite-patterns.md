# Web Elite Patterns (load on demand)

> **MANDATORY** for JSON-RPC bridges, PWA lifecycle, and host integration beyond bundled scripts. **NEVER** use raw `JavaScriptBridge.eval("localStorage.setItem('%s')" % data)` — use [web_local_storage_wrapper.gd](../scripts/platform_web_web_local_storage_wrapper.gd).

## PWA update lifecycle

```gdscript
func _ready() -> void:
    if OS.has_feature("web"):
        JavaScriptBridge.pwa_update_available.connect(_on_pwa_update)

func _on_pwa_update() -> void:
    if JavaScriptBridge.pwa_needs_update():
        JavaScriptBridge.pwa_update()
```

Also in SKILL.md — keep signal wiring on web feature gate.

## WebGPU status

Godot 4.x web ships **Compatibility (WebGL 2.0)** only. WebGPU is not a supported production renderer — do not design around it.

## JSON-RPC bridge (structured JS↔GD)

**MANDATORY** [web_json_rpc_bridge.gd](../scripts/platform_web_web_json_rpc_bridge.gd) for bidirectional browser messaging.

> **CAUTION:** Keep `create_callback` refs alive on the Node instance. Never interpolate untrusted JSON into `eval` strings.

## LocalStorage anti-pattern (do not ship)

```gdscript
# ❌ BAD — injection + escaping bugs
JavaScriptBridge.eval("localStorage.setItem('save', '%s')" % data)
```

Use `get_interface("localStorage")` via [web_local_storage_wrapper.gd](../scripts/platform_web_web_local_storage_wrapper.gd).

## Size optimization `project.godot`

```ini
[rendering]
textures/vram_compression/import_etc2_astc=true

[export]
exclude_filter="*.md,*.txt,docs/*"
```

## Performance targets

~60 FPS mid-range browsers; limit particles/draw calls; practical download budget ~50MB with exclude filters.

## COOP/COEP + HTTPS

Required for threads/`SharedArrayBuffer` and many secure-context APIs — host checklist in SKILL.md.

## Feature gate

```gdscript
if OS.has_feature("web"):
    pass  # visibility pause, navigation guard, storage wrapper
```
