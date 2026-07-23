# RenderingServer / PhysicsServer cookbook

Use when SceneTree nodes cannot meet tick budget — pair with [physics_server_direct.gd](../scripts/server_architecture_physics_server_direct.gd).

## RenderingServer canvas item (2D)

```gdscript
var canvas_item := RenderingServer.canvas_item_create()
RenderingServer.canvas_item_set_parent(canvas_item, get_canvas_item())
var texture_rid := load("res://icon.png").get_rid()
RenderingServer.canvas_item_add_texture_rect(
    canvas_item, Rect2(0, 0, 64, 64), texture_rid)
```

## PhysicsServer2D body

```gdscript
var body_rid := PhysicsServer2D.body_create()
PhysicsServer2D.body_set_mode(body_rid, PhysicsServer2D.BODY_MODE_RIGID)
var shape_rid := PhysicsServer2D.circle_shape_create()
PhysicsServer2D.shape_set_data(shape_rid, 16.0)
PhysicsServer2D.body_add_shape(body_rid, shape_rid)
```

> [!CAUTION]
> Every `*_create()` needs matching `free_rid()` on dedicated hosts.

## When to use servers vs nodes

| Servers | Nodes |
|---------|-------|
| Procedural swarms, voxels, mass particles | Gameplay actors, UI, prototyping |

Interest management: `MultiplayerSynchronizer.public_visibility = false` + visibility filter — see Host Patterns in SKILL.md.
