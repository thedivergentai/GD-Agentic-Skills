---
name: godot-gdscript-mastery
description: "Expert GDScript landmine guidance: static typing opcodes, signal-up/call-down, %UniqueName/@onready lifecycle, Callable bind/unbind, await sequences, typed collections, and safe Dictionary iteration. Use for code review, refactoring hot paths, or project standards. Trigger keywords: static_typing, signal_architecture, unique_nodes, @onready, class_name, signal_up_call_down, Callable.bind, typed_collections, await_sequence."
---

# GDScript Mastery

Expert guidance for writing performant, maintainable GDScript — Godot-landmine decision trees, not a style-guide reprint.

## Do NOT Load

- Do **not** load this skill for general prose style or Godot 3→4 migration checklists — those live in Official Documentation.
- Do **not** preload every script below; open only the MANDATORY pointer for the Core Directive you are implementing.
- Do **not** treat EditorScript utilities (`type_checker`, `performance_analyzer`, `signal_architecture_validator`) as runtime gameplay code.

## NEVER Do in GDScript

- **NEVER use `@onready` and `@export` on the same variable** — Initialization order will cause `@onready` to overwrite the Inspector value.
- **NEVER modify a Dictionary's size while iterating it** — Use `dict.keys().duplicate()` or iterate a clone to safely erase elements.
- **NEVER use string-based `connect("signal", ...)`** — Always use the Signal object syntax (`button.pressed.connect(...)`) for compile-time safety.
- **NEVER attempt to override non-virtual native engine methods** — Overriding `queue_free()` or `get_class()` is unsupported and will be ignored by engine callbacks.
- **NEVER use dynamic `get_node()` or `$` inside `_process()`** — Fetching paths every frame stalls the CPU. Cache and use `@onready`.
- **NEVER use `Parent.method()` calls** — Violates "Signal Up, Call Down". Use signals to communicate with parents.
- **NEVER use `is` followed by a hard cast** — If the type check passes but the object changes, it crashes. Use `as` and check for null.
- **NEVER use `print()` for production debugging** — Use `push_error()`, `push_warning()`, or breakpoints.
- **NEVER pre-load huge resources in `_ready()`** — Use `ResourceLoader.load_threaded_request()` for async loading.
- **NEVER use global variables in Autoloads when `static var` is sufficient** — Static variables offer better encapsulation.

---

## Godot 4.7: GDScript

- Typed override methods **inherit return type** — overrides require explicit `return` (add `return null` if needed).
- Setting packed array elements no longer invokes the whole-array property setter.

## Core Directives (decision trees + MANDATORY scripts)

### 1. Strong Typing & Performance
| Landmine | Decision |
|---|---|
| Hot path still `Variant`? | Annotate vars/returns; prefer typed collections |
| Generic math in `_process`? | Use typed helpers (`absf`, `ceili`, `clampf`) |
| Green safe-lines missing? | Fix inference with `:=` or explicit types |

> **MANDATORY**: [typed_collections_mastery.gd](scripts/typed_collections_mastery.gd), [array_preallocation_perf.gd](scripts/array_preallocation_perf.gd), [type_checker.gd](scripts/type_checker.gd) (EditorScript audit).

### 2. Signal Architecture
| Landmine | Decision |
|---|---|
| Child needs parent reaction? | Emit signal up — never call parent methods |
| Cross-script payload unsafe? | Typed `signal name(arg: Type)` |
| Connect visibility? | Prefer `_ready()` connects over invisible editor-only wiring |

> **MANDATORY**: [typed_signal_definitions.gd](scripts/typed_signal_definitions.gd), [signal_architecture_validator.gd](scripts/signal_architecture_validator.gd).

### 3. Node Access & Lifecycle Safety
| Landmine | Decision |
|---|---|
| Need child nodes? | `@onready` / `%UniqueName` — never in `_init()` |
| Scene-instanced node with ctor args? | Use `@export` injection — `_init(args)` breaks `PackedScene.instantiate()` |
| Path lookup every frame? | Cache once; never `$` / `get_node` in `_process` |

> **MANDATORY**: [safe_type_casting.gd](scripts/safe_type_casting.gd).

### 4. Callable & Signal (First-Class)
| Landmine | Decision |
|---|---|
| Extra context on callback? | `Callable.bind(...)` |
| Discard unused signal args? | `Callable.unbind(n)` |
| One-off timeout logic? | Inline lambda OK; keep refs if `create_callback`-style longevity matters |

> **MANDATORY**: [callable_binding_context.gd](scripts/callable_binding_context.gd), [unbind_signal_args.gd](scripts/unbind_signal_args.gd), [advanced_lambdas.gd](scripts/advanced_lambdas.gd), [functional_lambda_logic.gd](scripts/functional_lambda_logic.gd).

### 5. Async, Statics & Safe Collections
| Landmine | Decision |
|---|---|
| Sequence timers without threads? | `await` chains — see await manager |
| Global state without Autoload bloat? | `static var` (+ nullify large statics when done) |
| Erase while iterating Dictionary? | Clone keys first |

> **MANDATORY**: [await_sequence_manager.gd](scripts/await_sequence_manager.gd), [static_var_singleton_alt.gd](scripts/static_var_singleton_alt.gd), [dictionary_safe_iteration.gd](scripts/dictionary_safe_iteration.gd), [performance_analyzer.gd](scripts/performance_analyzer.gd) (EditorScript).

## Script Catalog (all files)

| Script | When to open |
|---|---|
| [typed_collections_mastery.gd](scripts/typed_collections_mastery.gd) | Typed Array/Dictionary opcodes |
| [functional_lambda_logic.gd](scripts/functional_lambda_logic.gd) | `reduce` / `all` / `any` |
| [advanced_lambdas.gd](scripts/advanced_lambdas.gd) | Higher-order Callables |
| [safe_type_casting.gd](scripts/safe_type_casting.gd) | `as` + null checks |
| [typed_signal_definitions.gd](scripts/typed_signal_definitions.gd) | Typed signal boundaries |
| [callable_binding_context.gd](scripts/callable_binding_context.gd) | `bind()` context injection |
| [unbind_signal_args.gd](scripts/unbind_signal_args.gd) | `unbind()` arity trim |
| [await_sequence_manager.gd](scripts/await_sequence_manager.gd) | Non-blocking await flows |
| [array_preallocation_perf.gd](scripts/array_preallocation_perf.gd) | `resize()` pre-alloc |
| [static_var_singleton_alt.gd](scripts/static_var_singleton_alt.gd) | Lightweight global state |
| [dictionary_safe_iteration.gd](scripts/dictionary_safe_iteration.gd) | Safe erase-while-iterate |
| [type_checker.gd](scripts/type_checker.gd) | EditorScript typing audit |
| [performance_analyzer.gd](scripts/performance_analyzer.gd) | EditorScript hot-path scan |
| [signal_architecture_validator.gd](scripts/signal_architecture_validator.gd) | EditorScript signal-up checks |

## Quick Landmines

- Prefer `dict.get("key", default)` over `dict["key"]` when presence is uncertain.
- Toggle **Access as Scene Unique Name** and read via `%Name` for critical UI/nodes.
- Script layout order: `extends` → `class_name` → signals/enums/consts → exports/onready → lifecycle → public → `_private`.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) — Language core for typed vars/funcs, `signal` declarations, `await`, and first-class Callables this skill standardizes.
- [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) — Canonical script order (`extends` → `class_name` → signals → exports → lifecycle → methods) used in reviews and refactoring.
- [Static typing in GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html) — Why typed Arrays/Dictionaries and return types unlock optimized opcodes and editor safe-lines.
- [GDScript: An introduction to dynamic languages](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_advanced.html) — Lambdas, higher-order Callables, and advanced patterns behind filter/map/reduce helpers.
- [GDScript warning system](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/warning_system.html) — Turn unsafe casts, unused signals, and untyped hot paths into CI-visible warnings.
- [Logic preferences](https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html) — When to prefer declarative signals vs imperative calls so scripts stay decoupled.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Official “signal up, call down” ownership rules this skill enforces.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Connect/emit model and why string-based connect-by-name is avoided.
- [Callable](https://docs.godotengine.org/en/stable/classes/class_callable.html) — `bind()` / `unbind()` APIs for injecting or discarding callback arguments without wrapper nodes.
- [Array](https://docs.godotengine.org/en/stable/classes/class_array.html) — Typed arrays, `resize()`, and functional methods (`filter`/`map`/`reduce`/`all`/`any`) used in the scripts.
- [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) — Safe `.get()` defaults and why size must not change while iterating keys.
- [CPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html) — Cache `@onready` / `%UniqueName` instead of `get_node`/`$` inside `_process` loops.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, Autoload registration, and scene ownership conventions that typed GDScript scripts plug into.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Component boundaries clarify which scripts own signals vs call-down APIs before style enforcement.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Deepens connect flags, buses, and sequencers after this skill’s typed signal/Callable basics.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Contrasts heavy Autoloads with the `static var` singleton alternatives shown here.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Prefer Resources for shared config; keep GDScript modules thin and typed around Resource payloads.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — `@onready`, unique names, and await sequences must stay valid across scene swaps and loaders.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — Typed signals and Callables make `watch_signals` / spies reliable in unit tests.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Pair style/perf smells from this skill with profiler and custom monitors when hot paths remain slow.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — FSM enter/exit handlers should follow the same typed-signal and await sequencing conventions.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when typed GDScript alone is not enough; servers, pooling, and broader CPU/GPU tactics live there.
- [godot-auditor](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md) — Project-wide audits consume the typing, signal-up, and hot-path rules codified in this skill.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Abilities need typed signal payloads and await-safe cooldowns grounded in these language patterns.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage/death fan-out depends on typed emits and safe casts taught here.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting scripting concern.
