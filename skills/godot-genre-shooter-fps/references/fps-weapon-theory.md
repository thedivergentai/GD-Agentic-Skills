# FPS Weapon Theory (load on demand)

> **MANDATORY** when implementing hitscan vs projectile tradeoffs, three-layer recoil, aim assist, net prediction, or weapon balance matrices beyond MANDATORY script reads.

## Hitscan vs projectile

| Mode | Use | Script |
|------|-----|--------|
| Hitscan | Pistols, ARs, snipers — instant feedback | [hitscan_weapon_query.gd](../scripts/hitscan_weapon_query.gd) |
| Projectile | Rockets, grenades — gravity arcs | [server_projectile_instance.gd](../scripts/server_projectile_instance.gd) (visual RID density) |

**WHY raycast not Area3D for bullets:** `PhysicsDirectSpaceState3D.intersect_ray` avoids per-bullet nodes at 60+ fire rate. Always `exclude` the shooter RID or shots hit the barrel instantly.

Muzzle forward: `-transform.basis.z` — not `Transform3D.looking_at()`.

## Three-layer recoil

1. **Visual kick** — camera pivot ([procedural_recoil_handler.gd](../scripts/procedural_recoil_handler.gd))
2. **Pattern offset** — learnable spray ([recoil_system.gd](../scripts/recoil_system.gd) `recoil_pattern` array)
3. **Spread bloom** — accuracy loss while firing; recover on release

**NEVER** apply recoil only to the gun mesh — players feel kick on the camera + bloom.

## Aim assist (controller)

[aim_assist.gd](../scripts/aim_assist.gd) — friction slowdown (≈0.3) within `assist_angle` + subtle screen-space magnetism (≈0.1). Disable or narrow on PC mouse builds.

## Weapon balance decision tree

| Archetype | Fire rate | Damage | Implementation |
|-----------|-----------|--------|----------------|
| SMG | High | Low | Tight vertical pattern |
| AR | Medium | Medium | Hitscan default |
| Shotgun | Burst | Per-pellet | 5–8 pellet spread, <10m effective |
| Sniper | Low | High | Hitscan + tracer visual |
| Rocket | Low | AoE | Projectile + gravity |

Sim asymmetry matrices in [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md).

## Multiplayer client prediction

```
CLIENT: play VFX/audio/recoil immediately → rpc_id(1, server_validate_shot, transform)
SERVER: authoritative ray → rpc confirm_hit OR rpc_id(sender, client_cancel_cast)
```

Server wins on mismatch — show "no reg" feedback. Do not sync every bullet; send fire events only.

## Polish checklist

- **Audio:** mechanical + shot + delayed tail — never one `AudioStreamPlayer`
- **Impacts:** Decal pool + fade — [bullet_decal_spawner.gd](../scripts/bullet_decal_spawner.gd)
- **Camera:** FOV punch + short shake on fire
- **Viewmodel:** [weapon_bobbing_system.gd](../scripts/weapon_bobbing_system.gd) + `Input.get_last_mouse_velocity()` sway

## Common pitfalls

| Symptom | Fix |
|---------|-----|
| Weak impacts | Triple-layer audio + shake + decal + damage number |
| Guns feel same | Unique `recoil_pattern` per weapon |
| No skill ceiling | Learnable patterns, not pure RNG spread |
| Controller frustration | Aim assist friction + magnetism |

TPS/cover/soft-lock not FPS-rig-specific → [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md).
