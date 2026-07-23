# Aurelius Protocol: Shaders Basics NEVER List

- **NEVER use `discard` unconditionally for optimization** — It prevents the depth prepass from working effectively. A discarded pixel still costs vertex processing; sometimes not rendering the object is better [1].
- **NEVER use `if/else` for dynamic states in high-performance shaders** — GPUs hate branching. Use `mix()`, `step()`, and `smoothstep()` for mathematical, hardware-optimized selection [5, 21].
- **NEVER compare floats exactly** — Hardware precision varies; `if (v == 0.5)` is unreliable. Use `abs(a - b) < epsilon` or `step()`.
- **NEVER use standard Alpha Blending for massive foliage** — It prevents shadows and SSR. Use Alpha Scissor or Alpha Hash (dithering) to enable depth prepass and shadow casting [7].
- **NEVER hardcode `POSITION` to `vec4(VERTEX, 1.0)` for full-screen quads in 4.3+** — Godot 4.3 uses Reversed-Z depth; this will cause clipping. Use `POSITION = vec4(VERTEX.xy, 1.0, 1.0)` [8, 9].
- **NEVER duplicate materials to change one color/value on many enemies** — Use `instance uniform`. This allows unique values for thousands of nodes while maintaining a single draw call (batching) [10].
- **NEVER use `TIME` without a speed multiplier** — Fragment speed should be controllable via uniforms to ensure consistency across different gameplay states.
- **NEVER forget `hint_source_color` for color uniforms** — Without it, the engine treats colors as linear math, leading to incorrect gamma and washed-out visuals in the inspector.
- **NEVER calculate complex math in `fragment()` that could be in `vertex()`** — `vertex()` runs once per point; `fragment()` runs millions of times per frame. Interpolate values via `varying` instead.
- **NEVER use `#define` macros for dynamic runtime toggles** — These create new shader permutations, causing massive compilation stutters when first encountered in-game. Use uniforms instead.
- **NEVER forget to normalize vectors** — Using `reflect(dir, normal)` on unnormalized vectors causes severe rendering artifacts and incorrect lighting math.
- **NEVER modify UV without bounds checking or `fract()`** — Shifting UVs beyond 0.0-1.0 without `repeat` wrapping or clamping will sample edge pixels or return black, breaking texture consistency.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — remediation after profiler confirmation
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
