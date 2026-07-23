---
name: godot-platform-web
description: "Expert blueprint for HTML5/web export on Compatibility (WebGL 2.0): JavaScriptBridge, localStorage wrapper, custom loading shells, COOP/COEP hosts, relative paths, beforeunload, visibility pause, and size optimization. WebGPU is out of scope. Keywords: web, HTML5, WebGL, Compatibility, JavaScriptBridge, localStorage, COOP, COEP, canvas, browser API."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Platform: Web

HTML5 export on **Compatibility / WebGL 2.0**. Browser storage, JS bridges, and host headers — not Forward+/WebGPU fantasy.

> **Out of scope / future:** WebGPU is **not** a supported Godot 4.x web renderer. Do not design production paths around it; ship **Compatibility (WebGL 2.0)** + VRAM compression.

## NEVER Do (Expert Web Rules)

### Persistence & Storage
- **NEVER use FileAccess alone for persistent web saves** — Prefer [web_local_storage_wrapper.gd](../scripts/platform_web_web_local_storage_wrapper.gd) (`localStorage` / IndexedDB via `JavaScriptBridge`).
- **NEVER assume localStorage is permanent** — Implement cloud-save fallback for production.

### Rendering & Logic
- **NEVER use the Forward+ renderer for web** — Use **Compatibility** (WebGL 2.0).
- **NEVER block the browser event loop** — Long sync work → "Kill the Page." Use `await` / threaded workers where available.
- **NEVER ignore COOP/COEP** — Threads/`SharedArrayBuffer` need cross-origin isolation.

### UX & Security
- **NEVER forget tab focus loss** — Pause audio on `visibilitychange`.
- **NEVER trigger Fullscreen/Mouse Lock without a click** — Must be inside a user gesture.
- **NEVER use absolute paths in HTML shells** — Relative paths for subdirectory hosting.

---

## Host checklist (procedure)

1. **HTTPS** — Required for many browser APIs (clipboard, some storage policies, secure contexts).
2. **COOP / COEP** — Serve isolation headers when enabling threads / `SharedArrayBuffer` (see exporting-for-web docs).
3. **Relative shell paths** — Custom `index.html` / PCK/WASM URLs must be relative so `/game/` subpaths work.
4. **`beforeunload`** — Wire [web_navigation_guard.gd](../scripts/platform_web_web_navigation_guard.gd) when unsaved progress exists.
5. **Compatibility renderer + texture compression** — Desktop browsers: S3TC/BPTC as appropriate; keep particle/draw budgets low.

## Available Scripts

> **MANDATORY**: For saves, load [web_local_storage_wrapper.gd](../scripts/platform_web_web_local_storage_wrapper.gd) — **do not** paste `JavaScriptBridge.eval("localStorage.setItem...")` string recipes.

### [web_local_storage_wrapper.gd](../scripts/platform_web_web_local_storage_wrapper.gd)
Quota-safe `localStorage` via `get_interface` + JSON (no eval string interpolation).

### [web_javascript_bridge_callback.gd](../scripts/platform_web_web_javascript_bridge_callback.gd)
Two-way JS↔GD with `create_callback` (keep callback refs alive).

### [web_responsive_canvas_adaptor.gd](../scripts/platform_web_web_responsive_canvas_adaptor.gd)
Canvas resize to browser viewport.

### [web_browser_input_guard.gd](../scripts/platform_web_web_browser_input_guard.gd)
Suppress context menu / spacebar scroll defaults.

### [web_resource_lazy_loader.gd](../scripts/platform_web_web_resource_lazy_loader.gd)
Remote PCK/resource fetch patterns.

### [web_clipboard_interface.gd](../scripts/platform_web_web_clipboard_interface.gd)
Async clipboard via Navigator API.

### [web_visibility_auto_pause.gd](../scripts/platform_web_web_visibility_auto_pause.gd)
Pause engine/audio on tab hide.

### [web_navigation_guard.gd](../scripts/platform_web_web_navigation_guard.gd)
`beforeunload` unsaved-progress guard.

### [web_external_url_opener.gd](../scripts/platform_web_web_external_url_opener.gd)
`window.open` with `noopener`.

### [web_performance_profiler.gd](../scripts/platform_web_web_performance_profiler.gd)
VRAM/draw stats to JS console.

### Also in `scripts/`
- [platform_web_patterns.gd](../scripts/platform_web_platform_web_patterns.gd) — Misc web feature gates.
- [web_bridge_sync.gd](../scripts/platform_web_web_bridge_sync.gd) — Structured bridge sync helper.

## Loading shell (custom HTML)

```html
<!-- index.html custom loading — keep asset URLs relative -->
<div id="loading-screen">
    <div class="progress-bar"><div id="progress" style="width: 0%"></div></div>
    <p id="status-text">Loading...</p>
</div>
<script>
const engine = new Engine(CONFIG);
engine.startGame({
    onProgress: function(current, total) {
        const percent = Math.floor((current / total) * 100);
        document.getElementById('progress').style.width = percent + '%';
        document.getElementById('status-text').innerText = `Loading ${percent}%`;
    }
}).then(() => {
    document.getElementById('loading-screen').style.display = 'none';
});
</script>
```

## Feature gate

```gdscript
if OS.has_feature("web"):
    # Web-only: storage wrapper, visibility pause, navigation guard
    pass
```

## Size / perf knobs

```ini
[rendering]
textures/vram_compression/import_s3tc_bptc=true
textures/vram_compression/import_etc2_astc=true
```

- Target ~60 FPS mid-range browsers; cut particles, draw calls, huge textures.
- Keep download under a practical budget (~50MB) via exclude filters on docs/source.

## PWA update hook

```gdscript
func _ready() -> void:
    if OS.has_feature("web"):
        JavaScriptBridge.pwa_update_available.connect(_on_pwa_update)

func _on_pwa_update() -> void:
    if JavaScriptBridge.pwa_needs_update():
        JavaScriptBridge.pwa_update()
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Exporting for the Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html) — Export presets, Compatibility/WebGL limits, and why COOP/COEP isolation is required for threads/`SharedArrayBuffer`.
- [Web export](https://docs.godotengine.org/en/stable/tutorials/platform/web/index.html) — Platform overview for HTML5 hosting constraints before wiring browser-only APIs.
- [The JavaScriptBridge singleton](https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html) — `eval`, `get_interface`, and `create_callback` contracts for two-way GD↔JS bridges.
- [Custom HTML page for Web export](https://docs.godotengine.org/en/stable/tutorials/platform/web/customizing_html5_shell.html) — Relative asset paths and custom loading shells so builds work under subdirectories.
- [HTML5 shell class reference](https://docs.godotengine.org/en/stable/tutorials/platform/web/html5_shell_classref.html) — `Engine`/`startGame` progress callbacks used by custom loading screens.
- [JavaScriptBridge](https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html) — PWA update signals plus clipboard/download helpers that must keep JS callback refs alive.
- [Introduction to the 3 rendering methods](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html) — Why web exports should ship **Compatibility** (WebGL 2.0) instead of Forward+.
- [File paths in Godot projects](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — Why `user://`/`FileAccess` persistence is unreliable in browser sandboxes versus `localStorage`/`IndexedDB`.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Serialize/version save payloads before wrapping them in browser storage APIs.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch/aspect/content scale paired with HTML canvas resize policy for responsive web viewports.
- [Handling quit requests](https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html) — Pause/resume lifecycle that maps to tab `visibilitychange` and `beforeunload` guards.
- [GPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html) — Draw-call, texture, and particle budgets that dominate WebGL frame time.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Feature tags (`web`), Compatibility renderer defaults, and display stretch settings every HTML5 export branch depends on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — InputEvent ownership before suppressing browser defaults (context menu, spacebar scroll) or remapping canvas focus.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Versioned save ownership and cloud-fallback hooks that `localStorage` wrappers must not invent ad hoc.

#### Complements
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Touch/lifecycle patterns that overlap when the same build is played in mobile browsers.
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Keep native desktop paths healthy when one project dual-targets desktop + web.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Bus/voice control used when tab visibility must pause playback to avoid background audio.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and CPU/GPU cuts when WebGL budgets still miss 60 FPS after Compatibility + compression.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Control layout that stays readable as the browser canvas resizes across desktop and phone web.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton homes for JavaScriptBridge managers, storage wrappers, and always-on visibility guards.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — WebSocket/WebRTC peers that replace LAN assumptions once the game is browser-hosted.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — PCK/resource packing contracts consumed by remote lazy-load fetch flows on web.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — CI presets, artifact hosting, and size gates after browser APIs and Compatibility settings are locked in.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering this platform skill beside sibling domains.
