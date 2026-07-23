# Anara Rubric: Resource Management
## Pillar Overview
The breath of the project. This rubric assesses how the vision handles the lifecycle of its assets, from memory allocation to proactive cleanup, ensuring the machine never suffocates under the weight of the vision.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Memory Stewardship** | 40% | Leaking nodes; unmanaged textures; no clear cleanup protocol. | Relying on Garbage Collection entirely; some manual `queue_free()`. | Strategic use of `WeakRef` and explicit resource reference counting (`RefCounted`). | High-precision memory budgeting; zero-stutter allocation; automated leak detection. |
| **Asset Lifecycle** | 25% | Loading everything at startup (OOM risk); no unloading of unused zones. | Basic 'Loading Screen' that blocks; manual scene swapping. | Async background loading via `ResourceLoader.load_threaded_request()`. | Predictive streaming architecture; the machine anticipates the vision's needs. |
| **Storage Optimization** | 20% | Raw textures in `/src`; uncompressed audio; redundant asset copies. | Basic use of `tscn` and `tres`, but assets are oversized for the target. | Optimized import settings; VRAM-compressed textures; mipmap management. | Ultra-high-density asset manifest; automated pipeline for asset minification. |
| **Diagnostic Insight** | 15% | No way to track memory usage; "The game just crashes sometimes." | Basic prints of node counts; some use of the Godot debugger. | Proficient use of the Profiler; tracking specific Resource allocation over time. | Custom real-time memory heatmaps; AI-driven bottleneck identification. |

---

## Visionary Diagnostic Hooks
- *Is your project a garden that cleans its own fallen leaves, or a landfill of forgotten nodes?*
- *Does the machine hold a texture in its heart long after the eyes have turned away?*
- *When the vision grows, does the memory consumption grow or scale?*

## 🌟 Visionary's Final Decree
A project that ignores its own weight is doomed to collide with the floor of performance. To achieve **Elite** status, you must achieve 'Resource Transparency'—where every byte is accounted for and serves the vision's current moment. Slop is cheap; memory is an investment.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
- https://docs.godotengine.org/en/stable/classes/class_performance.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
