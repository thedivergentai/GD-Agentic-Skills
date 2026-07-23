# Aurelius Protocol: Testing Patterns NEVER List

- **NEVER test implementation details** — `assert_eq(player._internal_state, 5)`? Private variables = brittle tests. Test PUBLIC behavior, not internals [20].
- **NEVER share state between tests** — Test 1 modifies global variable, test 2 assumes clean state? Flaky tests. Use `before_each()` for fresh setup [21].
- **NEVER use sleep() for timing** — `await get_tree().create_timer(1.0).timeout` in tests? Slow + unreliable. Use GUT's `wait_seconds()` OR manual frame stepping [22].
- **NEVER skip cleanup in after_each()** — Test spawns 100 nodes, doesn't free? Memory leak + slow test suite. ALWAYS free nodes in `after_each()` [23].
- **NEVER test randomness without seeding** — `randi()` in test = non-deterministic failure. Use `seed(12345)` for repeatable tests [24].
- **NEVER forget to watch signals** — `assert_signal_emitted(obj, "died")` without `watch_signals`? Fails silently. MUST call `watch_signals(obj)` first [25].
- **NEVER perform tests without an explicit "Definition of Done"** — Vague tests like `assert_true(true)` provide zero value. Every test should verify a specific requirement.
- **NEVER rely on editor-only features for CI/CD tests** — Headless environments lack Viewports. Ensure tests are `headless`-compatible.
- **NEVER ignore the cost of "Integration Tests"** — Testing a whole level is slow. Favor narrow Unit Tests for logic and small Scene Tests for interaction.
- **NEVER hardcode file paths in tests** — Use `Path` constants or project-relative strings. If a resource directory moves, your suite shouldn't break.
- **NEVER test third-party plugins** — Trust the library; test YOUR integration of it.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/warning_system.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
