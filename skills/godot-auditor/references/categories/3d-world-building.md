# Aurelius Protocol: 3D World Building NEVER List

- **NEVER forget to bake GridMap navigation** — GridMaps don't auto-generate navigation meshes. Use EditorPlugin or manual NavigationRegion3D.
- **NEVER use CSG for final game geometry** — CSG is for prototyping. Convert to static meshes for performance (use "Bake CSG Mesh" in editor).
- **NEVER scale GridMap cell size after placing tiles** — Changing `cell_size` doesn't update existing tiles, causing misalignment. Set it once at the start.
- **NEVER use MeshLibrary without collision shapes** — Items without collision spawn visual-only geometry that players fall through.
- **NEVER enable volumetric fog without DirectionalLight3D** — Volumetric fog requires at least one light to scatter. No lights = no visible fog.
- **NEVER animate CSG nodes during gameplay** — Moving a CSG node within another forces the CPU to recalculate the boolean geometry, causing significant performance drops.
- **NEVER place generic logic nodes in a GridMap** — GridMap is highly optimized only for meshes, navigation, and collision. It is not a general-purpose system for placing arbitrary node structures on a grid.
- **NEVER use non-manifold meshes in CSG** — If you import a custom mesh for CSGMesh3D, it must be manifold (closed, no self-intersections, no interior faces, no negative volume). Non-manifold meshes will break the CSG algorithm and are completely unsupported.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
