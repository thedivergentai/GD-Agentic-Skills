# Advanced shooter meta-systems

Load for lag compensation, explosion queries, and server rewind — pairs with [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md).

## Client prediction + server authority

```gdscript
# CLIENT — juice immediately
func fire_client() -> void:
    play_effects_immediate()
    local_tracer_only()
    rpc_id(1, "server_validate_shot", camera.global_transform)

# SERVER — damage only here
@rpc("any_peer")
func server_validate_shot(xform: Transform3D) -> void:
    var hit := perform_server_hitscan(xform)
    if hit and is_valid_shot(hit):
        rpc("confirm_hit", hit.victim_id, hit.damage)
```

- Predict tracers locally; never sync every bullet.
- Server wins on mismatch — show "no reg" feedback.
- Use ENet/UDP, not TCP, for fire events.

## Lag compensation (rewind)

Ring-buffer transforms; on shot, rewind targets to client timestamp, raycast, restore — [lag_compensator.gd](../scripts/genre_shooter_lag_compensator.gd).

> **CAUTION:** Rewind, raycast, and restore in **one** physics frame — leaving bodies displaced breaks other server sim.

## Shape explosion query

Sphere `intersect_shape` without Area3D spam — [shooter_patterns.gd](../scripts/genre_shooter_shooter_patterns.gd) pattern 3; also see explosion helper in patterns file.

## Hit zones

Use collider/shape names or bones for head/chest multipliers — avoid `==` on floats; use `is_equal_approx()` for damage math.

## Monte Carlo balance

Weapon matrices / TTK simulation → [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md).
