---
name: godot-debugging-profiling
description: "Expert debugging and profiling for leaks, GPU/Visual Profiler, headless CI QA, orphan nodes, thread-safe logs, and custom Debugger monitors — not print/breakpoint tutorials. Trigger on OBJECT_ORPHAN_NODE_COUNT, ObjectDB growth, Visual Profiler GPU spikes, flaky headless exits, or remote device consoles. Keywords: orphan nodes, Performance.get_monitor, Visual Profiler, Time.get_ticks_usec, EditorDebuggerPlugin, headless QA, push_error, backtrace."
---
## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Debugging & Profiling

Symptom → monitor/API → script routing for leaks, GPU, and CI — Official Docs cover print/breakpoint basics.

## NEVER Do

- **NEVER use `print()` without descriptive context** — `print(value)` is useless. Use `print("Player health:", health)` with labels.
- **NEVER leave debug prints in release builds** — Wrap in `if OS.is_debug_build()` or use custom DEBUG const. Prints slow down release.
- **NEVER ignore `push_warning()` messages** — Warnings indicate potential bugs (null refs, deprecated APIs). Fix them before they become errors.
- **NEVER use `assert()` for runtime validation in release** — Asserts are disabled in release builds. Use `if not condition: push_error()` for runtime checks.
- **NEVER profile in debug mode** — Debug builds are 5-10x slower. Always profile with release exports or `--release` flag.
- **NEVER assume `Engine.capture_script_backtraces(true)` is cheap** — Capturing locals allocates significant memory and can prevent objects from being deallocated, causing artificial leaks [19].
- **NEVER call `push_error()` or `print()` inside a custom `Logger._log_message` override** — This causes infinite recursion and crashes as the logger intercepts its own output [20].
- **NEVER leave the Visual Profiler running during gameplay tests** — Continuous polling degrades framerates significantly, invalidating actual performance metrics [21].
- **NEVER rely on `OS.get_ticks_msec()` for microbenchmarking** — Milliseconds lack precision for logic timing; ALWAYS use `Time.get_ticks_usec()` for microsecond precision [22].
- **NEVER assume `OBJECT_ORPHAN_NODE_COUNT` works in production** — This monitor is strictly debug-only; it safely returns 0 in release builds, potentially hiding leaks [23].
- **NEVER benchmark with V-Sync enabled** — V-Sync throttles metrics to the monitor refresh rate, masking the true CPU/GPU processing overhead [24].
- **NEVER leave `print_stack()` or `print_debug()` in release builds** — These are often stripped or useless outside the debugger. Use structured logging for production [25].
- **NEVER strip debugging symbols if using external C++ profilers** — Stripping destroys call stack readability for external tools like Perfetto or VerySleepy [26].
- **NEVER forget to unregister an `EditorDebuggerPlugin` in `_exit_tree()`** — Failing to clean up leaves "ghost" connections in the engine's debugging loop [27].
- **NEVER trust the Visual Profiler on macOS when using the Compatibility renderer** — Platform-specific driver limitations severely restrict OpenGL profiling accuracy on macOS [28].

## Symptom → Monitor → Script

> **MANDATORY** for the matching row. **Do NOT Load** every debug script for one bug.

| Symptom | Monitor / API | Script |
|---------|---------------|--------|
| Nodes removed but RAM climbs | `OBJECT_ORPHAN_NODE_COUNT` (debug) | **MANDATORY** [orphan_node_detector.gd](scripts/orphan_node_detector.gd) |
| ObjectDB / instance growth | custom monitors + dump | [memory_usage_threshold_alert.gd](scripts/memory_usage_threshold_alert.gd), [scene_tree_dump.gd](scripts/scene_tree_dump.gd) |
| GPU / overdraw mystery | Visual Profiler (briefly) | Pair with perf skill; use [performance_plotter.gd](scripts/performance_plotter.gd) for trends — do not leave Visual Profiler on |
| Flaky headless / CI exit | exit codes + asserts | **MANDATORY** [automated_qa_suite.gd](scripts/automated_qa_suite.gd), [push_error_safe_exit.gd](scripts/push_error_safe_exit.gd) |
| Microbenchmark lies | `Time.get_ticks_usec` | **MANDATORY** [high_precision_benchmarker.gd](scripts/high_precision_benchmarker.gd) |
| Crash needs locals | backtraces (debug only) | [advanced_backtrace_recorder.gd](scripts/advanced_backtrace_recorder.gd), [stack_trace_logger.gd](scripts/stack_trace_logger.gd) |
| Engine errors to backend | Logger intercept | [engine_error_interceptor.gd](scripts/engine_error_interceptor.gd) — never print inside Logger |
| Custom Debugger metrics | Monitors tab | [custom_editor_monitor.gd](scripts/custom_editor_monitor.gd), [debugger_tab_plugin.gd](scripts/debugger_tab_plugin.gd) |
| Mobile/console no stdout | in-game console | [remote_debug_console.gd](scripts/remote_debug_console.gd), [debug_overlay.gd](scripts/debug_overlay.gd) (debug builds only) |
| Thread races / log corruption | mutex logger / asserts | [thread_safe_logger.gd](scripts/thread_safe_logger.gd), [thread_safety_assert.gd](scripts/thread_safety_assert.gd) |
| Invisible logic (AI/physics) | debug draw / gizmos | [custom_debug_draw.gd](scripts/custom_debug_draw.gd), [property_watcher_gizmo.gd](scripts/property_watcher_gizmo.gd) |
| Conditional halt | hardcoded break | [break_on_condition.gd](scripts/break_on_condition.gd) |
| Editor vs runtime paths | `Engine.is_editor_hint` | [engine_editor_hint_logic.gd](scripts/engine_editor_hint_logic.gd) |

## Available Scripts (full catalog)

### Leaks & memory
- [orphan_node_detector.gd](scripts/orphan_node_detector.gd)
- [memory_usage_threshold_alert.gd](scripts/memory_usage_threshold_alert.gd)
- [scene_tree_dump.gd](scripts/scene_tree_dump.gd)

### Timing & QA
- [high_precision_benchmarker.gd](scripts/high_precision_benchmarker.gd)
- [automated_qa_suite.gd](scripts/automated_qa_suite.gd)
- [push_error_safe_exit.gd](scripts/push_error_safe_exit.gd)
- [performance_plotter.gd](scripts/performance_plotter.gd)

### Errors, stacks, threads
- [advanced_backtrace_recorder.gd](scripts/advanced_backtrace_recorder.gd)
- [stack_trace_logger.gd](scripts/stack_trace_logger.gd)
- [engine_error_interceptor.gd](scripts/engine_error_interceptor.gd)
- [thread_safe_logger.gd](scripts/thread_safe_logger.gd)
- [thread_safety_assert.gd](scripts/thread_safety_assert.gd)

### Editor / remote / viz
- [custom_editor_monitor.gd](scripts/custom_editor_monitor.gd)
- [debugger_tab_plugin.gd](scripts/debugger_tab_plugin.gd) — unregister in `_exit_tree()`
- [remote_debug_console.gd](scripts/remote_debug_console.gd)
- [debug_overlay.gd](scripts/debug_overlay.gd) — debug builds only
- [custom_debug_draw.gd](scripts/custom_debug_draw.gd)
- [property_watcher_gizmo.gd](scripts/property_watcher_gizmo.gd)
- [break_on_condition.gd](scripts/break_on_condition.gd)
- [engine_editor_hint_logic.gd](scripts/engine_editor_hint_logic.gd)

## Expert Pointers

- Profile release/`--release` with V-Sync off; never trust Debug-build timings.
- Prefer structured logs over `print_stack()` in anything that might ship.
- Escalate sustained FPS issues to `godot-performance-optimization` after the symptom tree identifies the bottleneck class.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Overview of debugging tools](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html) — Map of remote scene tree, breakpoints, Output, and profiler entry points before picking a deeper page.
- [Debugger panel](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/debugger_panel.html) — Stack, variables, breakpoints, errors, and monitors used for live remote debug sessions.
- [The profiler](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html) — Time and visual profilers: why you profile release-like builds and how frame charts isolate CPU/GPU spikes.
- [Output panel](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/output_panel.html) — How `print` / `push_warning` / `push_error` surface in the editor and why noisy release logs hide real faults.
- [ObjectDB profiler](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html) — Before/after ObjectDB snapshots for RefCounted cycles and leaked instances that orphan monitors miss.
- [Custom performance monitors](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html) — `Performance.add_custom_monitor` so game-specific metrics appear next to engine monitors.
- [Logging](https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html) — Custom `Logger` registration, file sinks, and recursion hazards when logging from inside log handlers.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — Headless `--script` / export flags for automated QA and CI exit-code runners.
- [CPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html) — Interpreting profiler hotspots into GDScript/server/thread fixes after measurement.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Worker-thread rules that motivate thread-safety asserts and mutexed loggers.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — Which servers/APIs may be called off-main-thread without corrupting the SceneTree.
- [Performance](https://docs.godotengine.org/en/stable/classes/class_performance.html) — Built-in monitors (`OBJECT_ORPHAN_NODE_COUNT`, memory, render) used by overlays and leak detectors.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Debug/release feature tags, project settings, and Autoload layout must exist before debugger plugins or global monitors.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Callables, `assert`/`push_error`, and `Time` APIs underpin benchmarks, breakpoints, and stack helpers.

#### Complements
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — After the profiler names a hotspot, apply pooling, culling, and MultiMesh fixes from that skill.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — GUT/assert/CI patterns pair with headless QA suites and deterministic `quit` exit codes.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Profile and remote-debug against real export templates; debug symbols and strip settings matter for external profilers.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Scene swap lifetime bugs show up as orphan-node growth; use tree dumps when loaders fail to free.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Ghost listeners and deferred connects often explain “why is this still running?” stack traces.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Global loggers, monitors, and error interceptors belong in Autoloads with clear boot order.
- [godot-server-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md) — When debug draw or metrics push into Rendering/Physics servers, keep server ownership separate from nodes.

#### Downstream / consumers
- [godot-auditor](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md) — Consumes debugger/profiler evidence when enforcing never-lists and architectural integrity reviews.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Device remote debug and on-screen consoles are required when desktop Output is unavailable.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Headless microbenchmarks and CI QA feed balance sims that need stable timing and exit codes.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Networked games need remote inspectors and structured logs across peers without flooding the Output panel.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting debug or perf concern.
