# Aurelius Protocol: Debugging Profiling NEVER List

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
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — remediation after profiler confirmation
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
