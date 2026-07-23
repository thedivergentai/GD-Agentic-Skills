# Expert testing patterns (GdUnit4)

This skill is **GdUnit4-only** (`extends GdUnitTestSuite`). GUT snippets in legacy baselines are historical — map asserts to GdUnit equivalents.

## State snapshot (JSON golden)

Serialize inventory/quest state to Dictionary; compare to golden JSON under `res://tests/goldens/`.

> [!CAUTION]
> Use `JSON.stringify(dict, "\t")` for human-readable git diffs.

Script: [snapshot_tester.gd](../scripts/testing_patterns_snapshot_tester.gd).

## Visual regression

`await RenderingServer.frame_post_draw` → capture viewport `Image` → byte-compare to `res://tests/snapshots/*.png`. Approve changes by regenerating goldens — never hand-edit PNG bytes.

## Headless CI

`godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test` with non-zero `OS.exit_code` on failure — [headless_test_runner.gd](../scripts/testing_patterns_headless_test_runner.gd).

## Fuzz input

Random `InputEventKey` via `Input.parse_input_event()` — [parameter_fuzz_tester.gd](../scripts/testing_patterns_parameter_fuzz_tester.gd). **Always seed** RNG.

## Performance gate

Track `Performance.TIME_PROCESS` and draw-call monitors over N frames — [performance_benchmark_runner.gd](../scripts/testing_patterns_performance_benchmark_runner.gd).

## Mock network

Loopback / offline peer before live ENet — [mock_network_provider.gd](../scripts/testing_patterns_mock_network_provider.gd).

## Validation helpers

Static asserts for health bounds, positions inside `Rect2` — keep in test utilities, not production builds.
