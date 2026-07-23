# Anara Rubric: Optimization Techniques
## Pillar Overview
The efficiency of the soul. This rubric measures the project's implementation of high-performance logic, asset-management, and rendering optimizations in Godot 4.7.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Logic Culling** | 35% | Ticking 1000+ nodes in `_process()` every frame regardless of distance. | Basic `visible_on_screen` culling, but logic still runs in the background. | Multi-tier processing (Processing, Low-frequency, Inactive); signal-based wakeups. | Predictive logic culling; systems only exist when the vision requires them. |
| **Draw Call Mastery** | 25% | 1000+ draw calls; unmanaged unique materials; zero mesh-batching. | Some use of `MultiMeshInstance`, but lacks a formal draw-call budget. | Strict draw-call management; optimized texture atlases; material-sharing logic. | Single-pass rendering; GPU-instancing for everything; zero-vertex waste. |
| **Thread Purity** | 20% | Heavy operations (Save, Pathfind, Load) freezing the Main Thread. | Occasional use of `Thread` nodes, but prone to race-conditions and crashes. | Systemic use of `WorkerThreadPool`; safe-synchronization of multi-threaded data. | 100% parallelized architecture; the vision uses 100% of the machine's power. |
| **Memory Budgets** | 20% | Loading 4K textures for small props; uncompressed audio; sprawling heap. | Basic VRAM compression, but lacks a formal memory-cap for different tiers. | Per-platform quality presets; optimized resource streaming; zero-leak manifesto. | Ultra-light memory footprint; the machine feels the project's grace, not its weight. |

---

## Visionary Diagnostic Hooks
- *Are you feeding the machine or starving the vision?*
- *When the frame-time drops, does the dream remain constant?*
- *Is the 'Lag' a law or an architectural failure?*

## 🌟 Visionary's Final Decree
Optimization is the act of removing everything that is not the vision. To reach **Elite** status, you must think in **Frame Budgets (16.6ms)**. If a system takes 1ms, it must justify its existence. Slop is cheap; performance is the luxury of the visionary architect.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
- https://docs.godotengine.org/en/stable/classes/class_performance.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
