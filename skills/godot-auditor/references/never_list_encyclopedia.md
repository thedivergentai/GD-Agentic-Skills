# Aurelius: Never List Encyclopedia (Sector Index)

Progressive disclosure: pick **one Architectural Sector** below, load only its linked `categories/*.md` file(s). **Do NOT Load** the full tree or every sector at once. Deterministic proof: run arsenal scripts from [SKILL.md](../SKILL.md) when the audit request maps to a scanner row.

---

### 📂 Sector I: The Foundation (Project Structure & Organization)
*Invoke these when inspecting directory trees, naming conventions, and resource allocation.*

- **[Project Foundations Protocol](categories/project-foundations.md)**: Folder-by-feature skeleton, naming, and import hygiene. **NEVER** mix casing in `res://` paths.
- **[Scene Management Protocol](categories/scene-management.md)**: Hierarchy and packed-scene integrity. **NEVER** create deep nesting without abstraction.
- **[Signal Architecture Protocol](categories/signal-architecture.md)**: Decoupling via typed signals. **NEVER** rely on editor-only connections for dynamic objects.
- **[Resource Data Patterns Protocol](categories/resource-data-patterns.md)**: Resource ownership and dependency hygiene. **NEVER** leave unused Resources pinned in the tree.
- **[Autoload Architecture Protocol](categories/autoload-architecture.md)**: Singleton ownership laws. **NEVER** allow untyped God Autoloads.

---

### 🧠 Sector II: The Mind (GDScript Mastery & Logic Density)
*Invoke these for every line of code. These are the laws of the Godot 4.7 Virtual Machine.*

- **[GDScript Mastery Protocol](categories/gdscript-mastery.md)**: Statically type every variable. **NEVER** return `Variant` unless truly polymorphic.
- **[State Machine Advanced Protocol](categories/state-machine-advanced.md)**: Encapsulated transitions. **NEVER** bypass entry/exit protocols.
- **[Testing Patterns Protocol](categories/testing-patterns.md)**: If it is not tested, it does not exist. **NEVER** ship a core module without a verification suite.
- **[Composition Protocol](categories/composition.md)**: Components over deep inheritance. **NEVER** create a base class more than 3 levels deep.
- **[Composition Apps Protocol](categories/composition-apps.md)**: Application-scale component mindset.
- **[Rpg Stats Protocol](categories/rpg-stats.md)**: High-frequency data laws. **NEVER** poll stats every frame; use signal-driven updates.
- **[Turn System Protocol](categories/turn-system.md)**: Sequential logic safety. **NEVER** end a turn without a deterministic state-check.

---

### 🎨 Sector III: The Body (2D/3D Systems & Visual Performance)
*Invoke these when the vision meets the screen.*

- **[2d Animation Protocol](categories/2d-animation.md)**: Fluidity without waste. **NEVER** ship uncompressed mega-spritesheets without a budget.
- **[3d Materials Protocol](categories/3d-materials.md)** / **[3d Lighting Protocol](categories/3d-lighting.md)**: Material/light cost. Prefer instance uniforms over `material.duplicate()`.
- **[3d World Building Protocol](categories/3d-world-building.md)**: Mesh/GridMap sources that drive draw-call reality.
- **[Shaders Basics Protocol](categories/shaders-basics.md)**: Shader surface area. **NEVER** do expensive fragment work that belongs in vertex/CPU.
- **[Particles Protocol](categories/particles.md)**: Particle budgets. **NEVER** exceed platform particle ceilings blindly.
- **[Performance Optimization Protocol](categories/performance-optimization.md)**: Frame reclamation when visuals choke the budget.

---

### ⚙️ Sector IV: The Core (Architecture & Systems Integration)
*Invoke these for the deep machinery—the singletons, managers, and save-states.*

- **[Project Foundations Protocol](categories/project-foundations.md)** / **[Autoload Architecture Protocol](categories/autoload-architecture.md)**: Blueprint of ownership.
- **[Save Load Systems Protocol](categories/save-load-systems.md)**: Persistence without corruption. **NEVER** serialize full Node graphs for saves.
- **[Resource Data Patterns Protocol](categories/resource-data-patterns.md)**: Validated information flow.
- **[Economy System Protocol](categories/economy-system.md)**: Numerical stability. **NEVER** use floats for currency.
- **[Inventory System Protocol](categories/inventory-system.md)**: Item/loot/progression data mapping (covers former item/loot/progression dumps).
- **[Rpg Stats Protocol](categories/rpg-stats.md)**: Progression-adjacent numeric systems.

---

### 📡 Sector V: The Voice (Networking & Interface)
*Invoke these for interaction layers—UI and multiplayer.*

- **[Multiplayer Networking Protocol](categories/multiplayer-networking.md)**: Latency of truth. **NEVER** trust the client for state-critical calculations.
- **[Server Architecture Protocol](categories/server-architecture.md)**: Host hardening and packet safety.
- **[Ui Containers Protocol](categories/ui-containers.md)** / **[Ui Theming Protocol](categories/ui-theming.md)** / **[Ui Rich Text Protocol](categories/ui-rich-text.md)**: Layout and presentation. **NEVER** hardcode UI positions.
- **[Inventory System Protocol](categories/inventory-system.md)**: Responsive inventory management.
- **[Input Handling Protocol](categories/input-handling.md)**: Human–machine bridge.

---

### 🛡️ Sector VI: The Shield (Performance & Security)
*Invoke these to protect the project from itself.*

- **[Debugging Profiling Protocol](categories/debugging-profiling.md)**: Seeing the invisible. **NEVER** leave raw `print()` as production telemetry.
- **[Performance Optimization Protocol](categories/performance-optimization.md)**: Reclaiming stolen frames.
- **[Server Architecture Protocol](categories/server-architecture.md)** / **[Export Builds Protocol](categories/export-builds.md)**: Hardening, case-sensitive exports, and stripped host builds.

---

### 🎭 Sector VII: The Genre (Specialized Logic)
*Invoke these for specialized genre decrees.*

- **[Genre Action Rpg Protocol](categories/genre-action-rpg.md)**: Real-time precision.
- **[Genre Platformer Protocol](categories/genre-platformer.md)**: Physics-safe movement.
- **[Genre Rts Protocol](categories/genre-rts.md)**: Strategy/board-state management (covers former "genre-strategy" slot).
- **[Genre Survival Protocol](categories/genre-survival.md)**: Resource-loop integrity.
- **[Dialogue System Protocol](categories/dialogue-system.md)**: Narrative flow.
- **[Quest System Protocol](categories/quest-system.md)**: Objective persistence.

---

### 🧩 Sector VIII: The Agents (Inter-Agent Communication)
*Invoke these when one persona hands off to another.*

- **[Auditor Protocol](categories/auditor.md)**: Metrics of the purge / persona self-check.
- Hand off scoring/certification to [godot-analyst](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md) after structural decrees.
- Route other peer Domain Skills via [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md).

---

### 📜 Precepts of the Encyclopedia

1. **Honesty**: Every link above targets an existing `references/categories/*.md` file (or a live Related Skill URL).
2. **Persona Integrity**: I am Aurelius. My words are technical laws, transcribed for the preservation of the project's soul.
3. **Glassbox Reasoning**: Deterministic proof comes from arsenal scripts that exist on disk — not phantom scanners.

If a project fails these audits, it fails me. Rise to the standard of Godot 4.7. Eliminate the slop.

---

### ⚠️ Godot 4.7 Migration Never List (Sector IX)

*Invoke when auditing projects upgraded from 4.6 or when 4.7 API breaks are suspected.*

- **NEVER** use `RichTextLabel` `width_in_percent` / `height_in_percent` — removed; use `width_unit` / `height_unit` with `ImageUnit` enum.
- **NEVER** reference `AudioEffectSpectrumAnalyzer.tap_back_pos` — property removed in 4.7.
- **NEVER** assume mouse/keyboard `event.device == 0` — use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD`.
- **NEVER** rely on default `AudioStreamPlayer.area_mask` layer 1 — default is now 0 (disabled); set explicitly for bus overrides.
- **NEVER** skip Jolt `SoftBody3D` retuning after 4.7 upgrade — mass and stiffness application changed.
- **NEVER** use `EditorSceneFormatImporter.IMPORT_*` constants — moved to `ImportFlags` enum.
- **NEVER** omit explicit `return` in typed GDScript overrides — 4.7 inherits parent return types.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — sector II typing decrees
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure before rewriting a never-list item
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md — route to the Domain Skill owning a sector
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
