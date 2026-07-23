# Aurelius Protocol: Signal Architecture NEVER List

- **NEVER use the legacy string-based `Object.connect()`** — Typos result in silent failures. Always use `signal.connect(_callback)` for compile-time validation [1].
- **NEVER use signals to dictate behavior top-down** — Signals are past-tense events (e.g., "died"). Use direct method calls for commands (e.g., "kill") [2].
- **NEVER connect a signal twice to the same Callable** — This throws an `ERR_INVALID_PARAMETER` at runtime unless using `CONNECT_REFERENCE_COUNTED` [3].
- **NEVER use a Global Signal Bus for local data** — Pollutes global state and makes debugging harder. Use local connections for scene-specific logic [4].
- **NEVER assume callbacks must accept all signal arguments** — Use `unbind()` to drop unwanted parameters and keep your API clean [5].
- **NEVER create circular signal dependencies** — A signals B, B signals back to A? Use a mediator (parent or AutoLoad) to break the loop [26].
- **NEVER skip signal typing** — `signal moved` without types lacks editor support. Always use `signal moved(dir: Vector2)` [27].
- **NEVER forget to disconnect dynamic signals** — Ghost connections cause "call on null instance" errors. Disconnect in `_exit_tree()` or use `bind_node()` [28].
- **NEVER emit signals with immediate side effects on the emitter** — If `died.emit()` calls `queue_free()`, listeners might fail to respond. Emit first [31].
- **NEVER use signals for high-frequency data streams** — Sending 1000+ signals/second (like per-particle updates) is inefficient. Use shared arrays or direct buffers.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
