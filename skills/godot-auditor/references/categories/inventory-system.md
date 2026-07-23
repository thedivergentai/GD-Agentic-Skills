# Aurelius Protocol: Inventory System NEVER List

- **NEVER use Nodes for items** — `Item extends Node` leads to massive SceneTree bloat and memory leaks. Always use `Item extends Resource` for lightweight data [20].
- **NEVER attempt to add items without checking stack limits** — Adding to an inventory without pre-scanning for existing stacks causes item duplication or loss [21].
- **NEVER allow the UI to modify the Inventory Data directly** — If UI code clears a slot without notifying the data model, you'll get desyncs and ghost items [22].
- **NEVER use `float` for item quantities** — Floating point errors (e.g. 0.9999 instead of 1) will break your "equal to zero" checks. Stick to `int` for counts [23].
- **NEVER add items before validating weight or volume capacity** — Moving validation check *after* adding the item makes it impossible to prevent over-encumbrance [24].
- **NEVER emit signals for every single item inside a batch operation** — Adding 50 items = 50 UI updates. Emit a single `inventory_updated` signal after the loop completes [25].
- **NEVER hardcode item references in scripts** — Use a String ID and a central `ItemDatabase` to look up resources. This is CRITICAL for save system compatibility.
- **NEVER ignore `is_instance_valid()` when accessing item icons** — If a slot's item is null, trying to access `.icon` will crash the UI.
- **NEVER use complex Array logic in the UI** — The UI should only "reflect" the data. All sorting, stacking, and filtering logic belongs in the `InventoryData` resource.
- **NEVER create new `Resource` instances inside a `_process()` loop** — Pre-instantiate your inventory slots or reuse existing ones to prevent allocation spikes.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
