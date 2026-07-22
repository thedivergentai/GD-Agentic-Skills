# Phase 4 — Economy, Retention & the Dopamine Loop

**Goal:** Validate the economic life of the player with the same rigor as combat difficulty. A perfectly-tuned level matrix is still a broken game if the shop is unreachable, a farm exploit exists, or the reward cadence has a dead plateau.

## Model every currency end-to-end

From the Phase 0 economy map, implement in the simulator:

- **In-run currency** (cash): kill rewards, wave bonuses, starting cash formulas (e.g. `cash = base + level_id * step`), and all sinks (upgrades, traps). Styles spend it according to `trap_budget_fraction`, `buys_upgrades`, `upgrade_cash_reserve`.
- **Meta currency** (coins/stars): first-clear rewards, **new-best deltas vs replay payouts** (track `coins_new_best` and `coins_replay` separately — this is how farm exploits are detected), mode payouts, challenge rewards.
- **Conversion rules**: e.g. `available stars = earned best-rating stars − purchase costs` — reproduce the exact bookkeeping of the game's save/progression code.

## Career simulation (`career` command)

`simulate_careers(data, style, input_model, runs)` chains full progressions and produces a `CareerTimeline`:

1. Start with a fresh save (starting purchases, level 1 unlocked).
2. Loop: attempt the frontier level with the current loadout under `style × input_model` → on win, apply rewards + unlocks; on loss, apply the style's fallback behavior (retry, or grind an earlier level / secondary mode for currency).
3. Mobile careers apply the `SessionModel` chunking: total wall-clock time is split into sessions (e.g. 3–7 minutes per session). Interruption frequency and session length caps dictate play windows.
4. Before each attempt, run the style's shopping policy against the shop price ladder (buy the intended next item when affordable above reserve).
5. Record per step: wall-clock minutes played, **sessions played to purchase**, attempts per level, currency balances over time, purchase timestamps, mode-play episodes.

Report per style × input model: **minutes-to-each-purchase, sessions-to-each-purchase, attempts-per-level distribution, currency balance curve, and total time/sessions to "complete" the content**. Run hundreds of careers to get distributions, not single anecdotes.

### Career red flags

- **Unreachable shop tier**: median career never affords an item before content ends → progression over-nerfed (the classic post-exploit-fix failure).
- **Zero-grind completion**: every item affordable on first pass → replay incentives are decorative, meta-economy too generous.
- **Grind walls**: a purchase requiring many repeats of already-mastered content (check minutes between purchases against the Phase 0 target, e.g. 5–15 casual minutes per meaningful purchase).
- **Dominant farm**: one level/mode yields far more currency/minute than everything else → all grinding collapses onto it (verify with the mode matrix's `coins_per_minute`).
- **Session overflow**: median level/run time exceeds the mobile session length cap → players quit mid-run; check whether progress/checkpoints are saved.
- **Session-boundary dead ends**: a session routinely ends with no purchase, unlock, or star gained → mobile dopamine macro-loop broken (design target: ≥1 visible progress event per 3–7 min session).

## Replayability & reward decay

Simulate the *repeat* case explicitly: what does re-clearing a done level pay? Healthy patterns pay a new-best delta plus a modest flat replay amount. Check:

- `coins_replay_avg × (60 / time_avg)` per level = replay currency/minute — must not dwarf frontier progression.
- Flat per-clear payouts scaling with grade (e.g. `coins = stars × 100` every clear) are farms; catch them by comparing replay income vs frontier income in the career sim.
- After nerfing, ALWAYS re-run careers to verify the shop ladder is still reachable (over-nerf check).

## Modes as economic organs

Every secondary mode (endless, deadline, strike, daily…) exists partly as an income stream and pacing valve. For each mode, from `ModeAggregate`:

- `coins_per_minute` per style × input model — compare across modes and vs story replay; keep them within a designed ratio (e.g. no mode > 1.5× the intended best) unless a mode is explicitly "the grind mode".
- Win rate per style × input model against its own band — modes have difficulty targets too.
- Career integration: styles like `grinder` should route through modes; verify the sim actually chooses them when they pay better.

## Interest curve

Plot (or tabulate) across the level sequence, per style × input model:

- Win rate and star average by level index — should trend gently downward in win rate (rising challenge) without cliffs or inversions (level N+1 easier than N is an inversion unless intentional as a breather).
- Intensity proxies by level: leaks, fault downtime, peak heat, time-to-first-fault — the *shape* should alternate tension and relief (breather levels are good; accidental dead plateaus of three same-intensity levels are not).
- New-content cadence: each level should introduce at least one new element (enemy, mechanic, unlock) — verify against the extraction data, and flag stretches with nothing new.

## Dopamine-loop checkpoints

Validate the reward cadence mechanically across platforms:

- **Micro loop (seconds)**: kills → cash → in-run purchase. Check `upgrades_avg`/`traps_placed_avg` > 0 for spending styles in every level; if cash pools unspent (`cash_end_avg` high), in-run sinks are mispriced.
- **Meso loop (platform-dependent)**:
  - **Mobile meso loop**: one session (3–7 min) → at least 1 clear / star / small shop purchase.
  - **Desktop meso loop**: one play block (20–40 min) → 3–5 clears / major upgrade / level unlock. Check star histograms give improvement room (not everyone 3★ or stuck at 1★).
- **Macro loop (days)**: purchases and unlocks at a steady wall-clock/session rhythm from the career timeline; flag gaps 3× longer than the median inter-purchase interval.

## Deliverable

An economy report section (text + JSON) covering: currency/minute matrix (level & mode × style × input model), career timelines with purchase timestamps (in minutes and sessions), replay-vs-frontier income ratios, interest-curve table, and explicit PASS/WARN flags for each red-flag rule above.

