# Aurelius Protocol: Gdscript Mastery NEVER List

- **NEVER use `@onready` and `@export` on the same variable** — Initialization order will cause `@onready` to overwrite the Inspector value [1].
- **NEVER modify a Dictionary's size while iterating it** — Use `dict.keys().duplicate()` or iterate a clone to safely erase elements [2, 3].
- **NEVER use string-based `connect("signal", ...)`** — Always use the Signal object syntax (`button.pressed.connect(...)`) for compile-time safety [4].
- **NEVER attempt to override non-virtual native engine methods** — Overriding `queue_free()` or `get_class()` is unsupported and will be ignored by engine callbacks [5, 6].
- **NEVER use dynamic `get_node()` or `$` inside `_process()`** — Fetching paths every frame stalls the CPU. Cache and use `@onready` [7, 8].
- **NEVER use `Parent.method()` calls** — Violates "Signal Up, Call Down". Use signals to communicate with parents.
- **NEVER use `is` followed by a hard cast** — If the type check passes but the object changes, it crashes. Use `as` and check for null.
- **NEVER use `print()` for production debugging** — Use `push_error()`, `push_warning()`, or breakpoints to ensure errors are visible in the console/logs.
- **NEVER pre-load huge resources in `_ready()`** — This causes frame stutters. Use `ResourceLoader.load_threaded_request()` for async loading.
- **NEVER use global variables in Autoloads when `static var` is sufficient** — Static variables offer better encapsulation and less project pollution [24].
- **Pattern**: "Signal Up, Call Down". Children should never call methods on parents; they should emit signals instead.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/warning_system.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
