# Expert navigation architectures

> Server-side RVO crowds, dynamic navmesh carving, and bake benchmarks. Prefer bundled `scripts/` when they cover the same pattern.

## Expert Navigation Architectures

### 1. Crowd Collision (Server-Side Avoidance)
For massive crowds, bypass node-based overhead by communicating directly with `NavigationServer3D`. Configure native server-side agents with RVO (Reciprocal Velocity Obstacle) parameters like `neighbor_distance` and `max_neighbors`.

```gdscript
class_name CrowdAgent3D extends CharacterBody3D
