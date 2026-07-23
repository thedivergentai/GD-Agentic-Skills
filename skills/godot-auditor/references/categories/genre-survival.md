# Aurelius Protocol: Genre Survival NEVER List

- NEVER use constant "Needs" decay; strictly scale with activity (e.g., **Sprinting** drains hunger 3x faster than idling).
- NEVER use Instant Death for starvation/dehydration; strictly trigger gradual HP drain and provide distinct visual/audio warnings.
- NEVER use float timers for exact life-critical checks; strictly use `is_equal_approx()` or `<=` to prevent 0.0 precision misses.
- NEVER represent world time/day cycles within UI scripts; strictly use an **AutoLoad (Singleton)** to decouple state from visuals.
- NEVER make gathering tedious without progression; strictly implement **Tiered Tool Scaling** (e.g., Stone Axe = 1 wood/hit, Steel Axe = 5 wood/hit) to reward technical advancement.
- NEVER allow infinite inventory stacking; strictly use **Weight Capacity** or strict **Stack Limits** (e.g., 64 items) to force strategic resource management.
- NEVER force players to "Guess" crafting recipes; strictly use a **Discovery System** where recipes unlock upon acquiring materials.
- NEVER forget to **duplicate(true)** a shared Resource (like Item Durability); otherwise, all instances will break simultaneously.
- NEVER store heavy item/crafting definitions in Node properties; strictly use custom **Resource** containers for lightweight data.
- NEVER spawn threats at Respawn Points; strictly enforce a **Safe Zone radius** (Beds/Spawn) where enemy spawning is prohibited.
- NEVER instance 10,000 individual `MeshInstance3D` nodes for foliage; strictly use **MultiMeshInstance3D** for batched draw calls.
- NEVER load massive world chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent hitches.
- NEVER save complex dictionaries to standard text files; strictly use binary serialization for speed and size efficiency.
- NEVER run procedural terrain/noise algorithms on the main thread; strictly offload to the **WorkerThreadPool**.
- NEVER hardcode massive crafting tables in GDScript; strictly use `ConfigFile` or JSON for easy balancing and modding.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
