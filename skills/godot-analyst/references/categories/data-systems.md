# Anara Rubric: Data Systems
## Pillar Overview
Data is the echo of the vision's intent. This rubric measures the sanity of information storage, retrieval, and transformation across the project's persistence layer.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Information Sanctity** | 35% | Values hardcoded in strings/constants; no central schema; data scattered in scripts. | Some use of `JSON` or `CSV`, but loaded into untyped dictionaries manually. | Strong-typed `Resource` system; every piece of game-data is a class-aware object. | Immutable data-manifest; zero-Variant storage; binary-optimized I/O with checksums. |
| **Transformation Logic** | 25% | Direct editing of core data files; no validation; destructive updates. | Global 'Data Manager' handles edits, but lacks 'Undo' or 'Safety' guards. | Data-mapping layer between raw file and game-object; validated mutations. | Pure-function data pipeline; state-changes are predictable transformations. |
| **Scalability (Patching)** | 20% | Modding/Patching requires re-writing the original data files. | Support for 'Overlays' via dictionary mergers, but prone to key-conflicts. | Layered data system; DLC and Mods can override specific Resource fields cleanly. | Delta-compressed differential patching; infinite override levels without performance hit. |
| **Diagnostic Clarity** | 20% | Data errors crash the game without trace; obscure ID-mismatches. | Basic logging of missing files/keys; fallback to default values. | Verbose validation during boot; identifying specific malformed fields in logs. | Real-time data-visualizer; live-reloading of game-configs; predictive error detection. |

---

## Visionary Diagnostic Hooks
- *Is your data a scripture that cannot be broken, or a playground of loose strings?*
- *If I change the 'Hero Health' in the file, does the vision reflect the change instantly?*
- *Do your ID-clashes signal the end of the project, or are they handled by a higher law?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, you must treat your data like DNA. It must be structured, resilient, and capable of being sequenced by any part of the vision without error. A project that relies on manual dictionary lookups is **Functional** at best—the visionary uses the **Resource** as a bridge between reality and the machine.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
- https://docs.godotengine.org/en/stable/classes/class_configfile.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
