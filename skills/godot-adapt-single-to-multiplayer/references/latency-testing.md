# Latency Testing (Local Multiplayer)

Use this reference when stressing a single-player→multiplayer migration. Keep `SKILL.md` as the architecture router; load this file when wiring `net_latency_simulator.gd`.

## When to load

- After host/join and authority paths work on localhost
- Before claiming reconciliation / interpolation are "done"
- Any time you change RPC reliability or sync intervals

## Golden path

1. **MANDATORY** load `scripts/net_latency_simulator.gd` and insert it on the multiplayer peer path (editor/debug builds only).
2. Start two clients (or host + client) against the same scene.
3. Apply a profile: **150 ms RTT**, **1–3% packet loss**, optional jitter ±30 ms.
4. Watch `scripts/net_debug_overlay_monitor.gd` for RTT / loss / jitter while playing the critical loop (move, shoot, interact).
5. Confirm server authority still rejects forged RPCs (`net_auth_server_validator.gd` / `rpc_bridge.gd`).

## Pass / fail gates

| Gate | Pass condition |
|------|----------------|
| Feel | Local input still predicts; remotes interpolate without rubber-band spikes |
| Authority | Illegal speed/position RPCs rejected on server |
| Late join | Mid-session join receives snapshot (`net_lobby_late_join_sync.gd`) |
| Bandwidth | Interest / delta compression still under budget with loss enabled |

## Do NOT

- Ship the latency simulator in release exports
- Treat 0 ms localhost success as multiplayer validation
- Raise sync rates to "hide" lag without measuring bandwidth

## Related scripts

- `net_latency_simulator.gd` — inject delay/loss
- `net_debug_overlay_monitor.gd` — on-screen RTT/loss
- `net_prediction_reconciliation.gd` / `net_snapshot_interpolation.gd` — fix feel after simulator fails
- `multiplayer_sync.gd` / `rpc_bridge.gd` — authority + transport bridges
