# Anara Rubric: TileMap Advanced
## Pillar Overview
The construction of the vision's world. This rubric measures the project's mastery of Godot 4 TileMapLayers, terrain-sets, and procedural tile placement.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Terrain Integrity** | 35% | Manual placement of every tile corner; no use of Terrain Sets; unaligned cells. | Basic Terrain Set usage for walls/floors, but results in 'Missing Seams' often. | Mastery of Terrain-Sets (Autotiles); 100% seamless transition logic; multi-layer sets. | Procedural terrain systems; dynamic tile-switching based on world-state (e.g. Snow). |
| **Layer Stewardship** | 25% | Everything on one layer; no separation of 'Shadow', 'Floor', 'Decoration'. | Basic use of 2-3 TileMapLayers, but with redundant data and unmanaged z-index. | Strategic Layering (Base, Deco, Hazard, Y-Sort); clean data-separation. | Adaptive layer management; dynamic layer-toggling for performance; zero-data-waste. |
| **Performance (Draw)** | 20% | Massive TileMaps (100k+ tiles) in a single node without culling or chunking. | Use of several TileMaps, but still suffers from high vertex-counts in 3D-scenes. | Optimized Tile-Atlases; minimal draw-calls; use of 'Baked' navigation on maps. | Chunked Tile-Systems; dynamic loading/unloading of regions; QuadTree optimization. |
| **World Interaction** | 20% | Tiles are just images; no collision or navigation built-in; manual 'Area2D' hacks. | Basic Collision/Navigation metadata on tiles, but results are stiff. | Custom Metadata per tile-type; tiles trigger logic when touched (Ice, Lava, Slipper). | Real-time Tile Manipulation; tiles are reactive world-bits; the world is the machine. |

---

## Visionary Diagnostic Hooks
- *Is the world a grid or a dream?*
- *When I place a 'Tile', does the machine understand the 'Earth'?*
- *Can the vision grow without the machine slowing to a crawl?*

## 🌟 Visionary's Final Decree
The TileMap is the skeleton of the world. To reach **Elite** status, your world must be 'Semantic'. A tile shouldn't just be 'Grass8'; it should be 'Walkable-Surface-Green'. Use **TileMapLayers** as independent data-tracks. A visionary builder knows every cell's purpose before it is ever drawn.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
