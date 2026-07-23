# Aurelius Protocol: Performance Optimization NEVER List

- **NEVER optimize without profiling first** — "I think physics is slow" without data? Premature optimization. ALWAYS use Debug → Profiler (F3) to identify actual bottleneck [20].
- **NEVER use `print()` in release builds** — `print()` every frame = file I/O bottleneck + log spam. Use `@warning_ignore` or conditional `if OS.is_debug_build():` [21].
- **NEVER ignore `VisibleOnScreenNotifier2D` for off-screen entities** — Enemies processing logic off-screen = wasted CPU. Disable `set_process(false)` when `screen_exited` [22].
- **NEVER instantiate nodes in hot loops** — `for i in 1000: var bullet = Bullet.new()` = 1000 allocations. Use object pools, reuse instances [23].
- **NEVER use `get_node()` in `_process()`** — Calling `get_node("Player")` 60x/sec = tree traversal spam. Cache in `@onready var player := $Player` [24].
- **NEVER forget to batch draw calls** — 1000 unique sprites = 1000 draw calls. Use TextureAtlas (sprite sheets) + MultiMesh for instanced rendering [25].
- **NEVER block the main thread for heavy operations** — Avoid `OS.delay_msec()` or long synchronous data processing. Use `WorkerThreadPool` to keep framerates steady.
- **NEVER use complex collision shapes for physics queries** — High-poly convex shapes are expensive to resolve. Prefer simplified primitives (Circle, Rectangle, Box).
- **NEVER forget to disconnect local lambda signals** — Anonymous lambdas connected to global signals can cause memory leaks if the capturing object is freed.
- **NEVER use large textures without compression** — VRAM is limited. Use VRAM Compressed (S3TC/BPTC) for fast lookup and reduced memory footprint.
- **NEVER perform tree modifications during physics steps** — Adding/removing nodes during `_inter_ray` or `_physics_process` can lock the physics server. Use `call_deferred`.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
