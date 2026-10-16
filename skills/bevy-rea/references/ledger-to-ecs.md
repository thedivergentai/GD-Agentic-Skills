# Ledger row to ECS

A ledger row becomes one plugin. The plugin does not grow components until the suggested Bevy skill is loaded.

| Status | Plugin contents |
| --- | --- |
| `confirmed` | Empty `Update` system. The name existed in the artifact. The body did not. |
| `partial` | Same empty system. The comment records `status=partial`, the evidence path, the suggested Bevy skill, and the detail string. |
| `unknown` | Same empty system so `COVERAGE.md` still has the id. |

## Schedule

The stub runs on `Update` and is not chained. `.chain()` is for two systems that mutably query the same component. This plugin has no `Query`.

A later skill moves simulation to `FixedMain` when the work is a physics step, and moves spawn to `Startup` with `Commands` when the work creates entities. Do not put `Commands` on the stub. There is nothing to spawn yet.

`DefaultPlugins` owns the window, input, and renderer. Do not add a second copy.

## Asset bytes

Copy into `assets/<module><suffix>` only when `--allow-assets` is set and that entry's `license` is not blank or `unspecified`. Prefer `copied`, then `source_path`. Otherwise write `placeholders/<module>.txt`.

## Official types

- [App](https://docs.rs/bevy/latest/bevy/app/struct.App.html) — `App::new` and `add_plugins`.
- [Plugin](https://docs.rs/bevy/latest/bevy/app/trait.Plugin.html) — one impl per ledger id.
- [Update](https://docs.rs/bevy/latest/bevy/app/struct.Update.html) — schedule for the empty stub.
