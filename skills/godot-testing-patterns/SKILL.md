---
name: godot-testing-patterns
description: "Expert testing decision trees for GdUnit4: unit vs scene vs CI gates, headless runners, snapshots, and mock networks. Use when choosing test layers, wiring CI, or validating signals/physics without beginner assert catalogs. Keywords: GdUnit4, GdUnitTestSuite, headless CI, snapshot test, mock network, scene integration test, TDD."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Testing Patterns (GdUnit4)

**Framework: GdUnit4 only** (`extends GdUnitTestSuite`). Do not mix GUT `GutTest` / `watch_signals` APIs in new tests.

## Decision Tree → Scripts

| Need | Choice | Script (MANDATORY when chosen) |
| :--- | :--- | :--- |
| Pure logic / no tree | Unit | [basic_unit_test.gd](scripts/basic_unit_test.gd), [mock_dependency_test.gd](scripts/mock_dependency_test.gd), [test_data_factory.gd](scripts/test_data_factory.gd) |
| Node interaction after instantiate | Scene integration | [scene_integration_test.gd](scripts/scene_integration_test.gd), [integration_test_base.gd](scripts/integration_test_base.gd) |
| Signal contracts | Unit or scene | [signal_emission_test.gd](scripts/signal_emission_test.gd) |
| Multi-frame / physics step | Async scene | [wait_for_frame_test.gd](scripts/wait_for_frame_test.gd), [physics_collision_test.gd](scripts/physics_collision_test.gd) |
| Flaky physics / timing races | Frame step gate | **MANDATORY** [wait_for_frame_test.gd](scripts/wait_for_frame_test.gd) — never wall-clock sleep |
| CI / no display | Headless gate | **MANDATORY** [headless_test_runner.gd](scripts/headless_test_runner.gd) |
| Save/UI regression | Snapshot | **MANDATORY** [snapshot_tester.gd](scripts/snapshot_tester.gd) |
| RPC without live peers | Mock network | **MANDATORY** [mock_network_provider.gd](scripts/mock_network_provider.gd) |
| Perf budget in CI | Benchmark gate | [performance_benchmark_runner.gd](scripts/performance_benchmark_runner.gd) |
| Orphans after suite | Leak detect | [memory_leak_detector.gd](scripts/memory_leak_detector.gd) |
| Edge input space | Fuzz | [parameter_fuzz_tester.gd](scripts/parameter_fuzz_tester.gd) |

**Do NOT Load** assert-catalog tutorials or manual gameplay checklists into context — pick a row, read the script, implement.

## MANDATORY Triggers

- **CI / `--headless`**: always read [headless_test_runner.gd](scripts/headless_test_runner.gd) first (`OS.exit_code`, GdUnit4 CLI: `godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test`).
- **State or visual golden files**: read [snapshot_tester.gd](scripts/snapshot_tester.gd) before writing JSON/image goldens. **Approve workflow:** first run saves reference; intentional UI change → delete or overwrite `res://tests/snapshots/<name>.png`, re-run to regenerate, commit new golden; never hand-edit PNG bytes.
- **Any RPC / MultiplayerSynchronizer test**: read [mock_network_provider.gd](scripts/mock_network_provider.gd) before standing up real peers.

## Available Scripts

### [basic_unit_test.gd](scripts/basic_unit_test.gd)
Minimal GdUnit4 (`GdUnitTestSuite`) structure for pure logic.

### [signal_emission_test.gd](scripts/signal_emission_test.gd)
Signal emission monitoring for decoupled architectures.

### [mock_dependency_test.gd](scripts/mock_dependency_test.gd)
Mocks/doubles to isolate external services.

### [scene_integration_test.gd](scripts/scene_integration_test.gd) / [integration_test_base.gd](scripts/integration_test_base.gd)
Scene lifecycle + node interaction fixtures.

### [headless_test_runner.gd](scripts/headless_test_runner.gd)
CI headless orchestration and exit codes.

### [snapshot_tester.gd](scripts/snapshot_tester.gd)
Dictionary/UI golden snapshot comparison.

### [mock_network_provider.gd](scripts/mock_network_provider.gd)
Loopback / offline multiplayer peer for RPC tests.

### [performance_benchmark_runner.gd](scripts/performance_benchmark_runner.gd)
Microsecond timers + Performance monitor gates.

### [memory_leak_detector.gd](scripts/memory_leak_detector.gd)
Orphan node detection across long suites.

### [parameter_fuzz_tester.gd](scripts/parameter_fuzz_tester.gd)
Randomized ranges for edge crashes.

### [wait_for_frame_test.gd](scripts/wait_for_frame_test.gd) / [physics_collision_test.gd](scripts/physics_collision_test.gd)
Frame/physics-step async verification.

### [test_data_factory.gd](scripts/test_data_factory.gd)
Schema-compliant fixture builders.

## NEVER Do in Testing (GdUnit4)

- **NEVER test private implementation details** — Assert public behavior only.
- **NEVER share mutable state between tests** — Fresh setup per test (`before_test` / equivalent).
- **NEVER use wall-clock `sleep` / blind timers** — Prefer frame steppers from wait_for_frame patterns.
- **NEVER skip cleanup** — Free instantiated nodes after each test.
- **NEVER test randomness without seeding**.
- **NEVER assert signals without the GdUnit signal assert/monitor helpers** from [signal_emission_test.gd](scripts/signal_emission_test.gd).
- **NEVER mix GUT and GdUnit4 APIs** in one suite.
- **NEVER rely on editor-only features for CI** — Headless-compatible tests only.
- **NEVER default to full-level integration tests** — Prefer unit + small scene tests; escalate only when the decision tree says so.
- **NEVER hardcode brittle absolute file paths** in fixtures.
- **NEVER test third-party plugin internals** — Test your integration only.

## Expert Gates (short)

- **Snapshot**: serialize → compare golden ([snapshot_tester.gd](scripts/snapshot_tester.gd)); regenerate reference PNG on approved visual changes.
- **CI**: `--headless` + `OS.exit_code` non-zero on failure ([headless_test_runner.gd](scripts/headless_test_runner.gd)).
- **Network**: mock peer before real ENet (`mock_network_provider.gd`).
- **Perf**: `Performance` monitors / draw-call caps in benchmark runner.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless`, `-s`, and exit-code patterns for CI test runners.
- [Overview of debugging tools](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html) — debugger, profiler, and remote inspect when a failing test needs engine-side diagnosis.
- [Custom performance monitors](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html) — `Performance` monitors and custom metrics for benchmark gates and orphan detection.
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — frame/`_physics_process` timing that `wait_frames` / yield helpers must respect.
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — tree lifecycle, `quit()`, and process modes used by headless orchestrators.
- [Nodes and scene instances](https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html) — instantiate/add_child/free hygiene for scene integration tests.
- [Instancing with signals](https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html) — signal wiring patterns that signal-emission tests verify.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC/peer APIs mocked via OfflineMultiplayerPeer or latency simulators.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — synthetic `InputEvent*` injection for fuzz and UI interaction tests.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — seeding for deterministic fuzz and Monte Carlo harnesses.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — serialize/deserialize patterns behind golden JSON and save/load integration tests.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — layers/masks and step timing for collision integration tests.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project layout, scenes, and resources before standing up a `res://test/` suite.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed GDScript, `await`, and assert idioms used in every unit/integration test.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — emit/connect contracts that `watch_signals` / signal monitors assert against.

#### Complements
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — profiler and ObjectDB tools when a red test needs runtime evidence, not another assert.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — scene packing/load patterns mirrored in scene integration fixtures.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — action maps and event parsing exercised by fuzz and UI press tests.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — layer matrices and body APIs that physics collision tests must keep green.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource schemas that test data factories and snapshot dictionaries serialize.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — persistence pipelines covered by save/load integration and golden-state tests.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — seeded headless gameplay sims that reuse these harnesses for Phase 7 golden cells.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — budgets that CI performance gates (`Performance` monitors, draw-call caps) enforce.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — RPC/replication logic validated through mock peers and lag injection.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — headless export/CI pipelines that invoke the same `--headless` test entrypoints.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
