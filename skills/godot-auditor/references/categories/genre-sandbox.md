# Aurelius Protocol: Genre Sandbox NEVER List

- NEVER use individual `RigidBody` nodes for every block; strictly use **Static Colliders** for the world and reserve physics for dynamic props.
- NEVER simulate the entire world every frame; strictly process **"Dirty" chunks** with active changes. Sleeping chunks must consume zero CPU.
- NEVER update `MultiMesh` buffers every frame; strictly **batch changes** and only rebuild the buffer when a modification completes (e.g., player stops painting).
- NEVER use standard Godot `Nodes` for every grid cell; strictly use **PackedInt32Arrays** or typed Dictionaries to keep RAM overhead minimal.
- NEVER raycast against every individual voxel for placement; strictly use **Grid Quantization** (`floor(pos/size)`) for direct O(1) cell calculation.
- NEVER render every block face in a chunk; strictly generate an `ArrayMesh` that only pushes **visible exterior faces** to the GPU (Culling/Greedy Meshing).
- NEVER save raw arrays of every block transform; strictly use **Run-Length Encoding (RLE)** (e.g., "Air x 50,000") to compress uniform spaces.
- NEVER load massive terrain chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stutter.
- NEVER use standard text `.tscn` files for voxel datasets; strictly use **binary `.res` files** for 10x faster parsing.
- NEVER ignore **Floating-Point Precision limits** (32,768 units); strictly implement floating-origin shifting for massive worlds.
- NEVER hardcode element interactions (`if water and fire`); strictly use a **Property System** where interactions emerge from material attributes (flammability, density).
- NEVER trust client-side placement in multiplayer; strictly require the **Server to validate** bounds and resources.
- NEVER manipulate the SceneTree from background generation threads; strictly use `call_deferred()` or Mutex locks for safety.
- NEVER leave orphaned chunks in memory; strictly track loaded regions and call `queue_free()` on discarded branches.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
