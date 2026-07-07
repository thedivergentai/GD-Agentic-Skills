# 📜 Aurelius Expert Audit Standards (Godot 4.7+)

This document defines the technical benchmarks for the **Aurelius Protocol**. These standards represent the "Gold Standard" for professional-grade Godot 4.7 development.

---

## 🏛️ Architectural Integrity (The "Foundational Pillars")

### 1. The Bridge Pattern (UI-to-Logic)
*   **Standard**: Direct node references between UI and Game Logic are **PROHIBITED**.
*   **Expert Pattern**: Use a "Bridge" Resource or a dedicated "UIController" that listens for Signal Bus events.
*   **Reasoning**: Decouples UI skinning from core mechanics, allowing for easy UI redesigns without breaking game logic.

### 2. Signal Topology (The "Signal-Up" Mandate)
*   **Standard**: Signals must flow **UP** the scene tree. Calls must flow **DOWN**.
*   **Violation**: A child node calling `get_parent().update_score()`.
*   **Correct Protocol**: Child emits `score_changed(delta)`; Parent connects to its child and handles the method call.

### 3. Composition via Node-Components
*   **Standard**: Favor shallow inheritance (max 3 levels). Use "Actor Components" (Node-based) for reusable behaviors.
*   **Expert Pattern**: `HitboxComponent`, `HealthComponent`, `AIControllerComponent`.

---

## ⚡ Performance Protocol (Godot 4.7 Nuances)

### 1. The "Main Thread" Sanctuary
*   **Standard**: Any operation taking > 2ms (e.g., massive JSON parsing, long-distance pathfinding) MUST be offloaded.
*   **Expert Pattern**: Use `WorkerThreadPool.add_task()` for data-heavy tasks. Use `Thread` only for dedicated long-running background loops.

### 2. RID-Level Management (Rendering Slop)
*   **Standard**: Direct `RenderingServer` calls for thousands of objects instead of тысячи `Sprite2D` nodes.
*   **Expert Pattern**: Use `RenderingServer.canvas_item_create()` and RIDs for high-density particle/projectile systems outside of GPUParticles.

### 3. Type Safety & Hashing
*   **Standard**: Typed Dictionaries and Arrays for ALL public APIs.
*   **Expert Pattern**: Use `StringName` (&"name") for all dictionary keys, signal names, and animation calls to avoid redundant hashing at runtime.

---

## 🛡️ Never vs Always (Expert Checklist)

| Topic | ❌ NEVER (Legacy Slop) | ✅ ALWAYS (Expert Protocol) |
| :--- | :--- | :--- |
| **Signals** | `connect("string", ...)` | `signal_object.connect(callable)` |
| **Containers** | `var data := {}` | `var data: Dictionary[int, Resource] = {}` |
| **Nodes** | `get_node("../Sibling")` | `@export var sibling: Node` |
| **Strings** | `var x = "name"` | `var x = &"name"` (StringName) |
| **Timers** | `get_tree().create_timer()` | Reusable `Timer` node or manual `delta` accumulation. |
| **Loading** | `load("res://path")` | `preload("res://path")` or `ResourceLoader` background tasks. |

---
*Reference version 2.0.0 | Aurelius Protocol Authorized | Godot 4.7+ Verified*
