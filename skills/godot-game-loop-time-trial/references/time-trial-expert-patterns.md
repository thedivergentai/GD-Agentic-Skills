# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Expert Time Trial Patterns

### 1. Delta-Compression for Ghosts
Instead of recording every frame, only store a new "keyframe" if the player's position or rotation has changed beyond a threshold.

- **Storage**: Use `FileAccess.open_compressed()` with `FileAccess.COMPRESSION_ZSTD` for maximum efficiency.
- **Binary**: Save as raw floats/integers rather than JSON to reduce file size by ~80%.

### 2. The Leaderboard Bridge
Standardize time formatting across your game to avoid precision issues.

- **Precision**: Store records in `msec` (int) or `usec` (int) to avoid float rounding errors.
- **Formatting**: Use `%02d:%02d.%03d` format strings for consistent UI display (e.g., `01:24.450`).
