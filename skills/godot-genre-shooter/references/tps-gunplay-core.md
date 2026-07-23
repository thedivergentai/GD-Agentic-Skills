# TPS / hybrid gunplay core

Shared combat theory for this skill (TPS, cover, soft-lock). FPS viewmodel/recoil polish → [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md).

## WeaponData (never hardcode in nodes)

```gdscript
class_name WeaponData extends Resource

@export var damage: int = 20
@export var fire_rate: float = 0.1
@export var magazine_size: int = 30
@export var range: float = 100.0
@export var is_hitscan: bool = true
@export var projectile_scene: PackedScene
```

Balance in `.tres`, not scattered `@export` on scene logic.

## Hitscan vs projectile

| Mode | When | Script |
|------|------|--------|
| Hitscan | Rifles, SMGs — instant feedback | [shooter_patterns.gd](../scripts/shooter_patterns.gd), [advanced_weapon_controller.gd](../scripts/advanced_weapon_controller.gd) |
| Projectile | Rockets, arrows — gravity/bounce | [projectile.gd](../scripts/projectile.gd) |

Hitscan must run in `_physics_process` with `PhysicsDirectSpaceState3D.intersect_ray`, **not** `_process` or `Area3D` overlap.

```gdscript
var query := PhysicsRayQueryParameters3D.create(origin, origin + dir * range)
query.exclude = [shooter.get_rid()]
query.collision_mask = enemy_mask
var hit := space.intersect_ray(query)
```

## Recoil (three layers)

1. **Camera kick** — visual rotation, recover over time
2. **Spread bloom** — accuracy loss while firing
3. **Learnable pattern** — `Array[Vector2]` spray resource ([weapon_recoil_pattern.gd](../scripts/weapon_recoil_pattern.gd))

> **NEVER** apply recoil only to weapon mesh — players feel kick via camera + crosshair spread.

## TPS-specific

| System | Script |
|--------|--------|
| Over-shoulder camera | [tps_camera_spring_arm.gd](../scripts/tps_camera_spring_arm.gd) |
| Cover validity | [cover_validator_rays.gd](../scripts/cover_validator_rays.gd) |
| Soft-lock / assist | [soft_lock_aim_assist.gd](../scripts/soft_lock_aim_assist.gd) |

Controller assist: friction near targets + subtle magnetism — tune in soft-lock script; do not snap aim.

## Weapon balance heuristics

| Archetype | Feel |
|-----------|------|
| SMG | High ROF, low damage, tracking aim |
| Sniper | Low ROF, high damage, precision |
| Shotgun | Multi-pellet spread, <10m effective |
| AR | Medium all stats |

Hitscan for bullets; physical sim for explosives.

## Feel polish

- Layered gunfire audio (mechanical + shot + tail) on separate `AudioStreamPlayer3D` — [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md)
- Impact **Decal** nodes, not flat `Sprite3D` billboards
- Crosshair: anchor center, not pixel offsets

## Pitfalls

| Symptom | Fix |
|---------|-----|
| Weak impacts | Triple audio + shake + decal + damage number |
| Identical guns | Unique spray patterns per archetype |
| No skill ceiling | Learnable patterns, not pure RNG |
| Controller frustration | Soft-lock + friction, not zero assist |
