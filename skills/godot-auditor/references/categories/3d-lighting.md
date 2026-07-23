# Aurelius Protocol: 3D Lighting NEVER List

- **NEVER use VoxelGI without setting a proper extents** — Unbound VoxelGI tanks performance. Always set `size` to tightly fit your scene.
- **NEVER enable shadows on every light** — Each shadow-casting light is expensive. Use shadows sparingly: 1-2 DirectionalLights, ~3-5 OmniLights max.
- **NEVER forget directional_shadow_mode** — Default is ORTHOGONAL. For large outdoor scenes, use PARALLEL_4_SPLITS for better shadow quality at distance.
- **NEVER use LightmapGI for fully dynamic scenes** — Lightmaps are baked. Moving geometry won't receive updated lighting. Use VoxelGI or SDFGI instead.
- **NEVER set omni_range too large** — Light attenuation is quadratic. A range of 500 affects 785,000 sq units. Keep range as small as visually acceptable.
- **NEVER hide a Light node using the Visible property to exclude it from a Lightmap bake** — Hiding a light has no effect on the baker. You must change the light's Bake Mode to Disabled.
- **NEVER use VoxelGI with paper-thin walls** — VoxelGI evaluates lighting using a 3D grid. Thin walls (less than one voxel thick) will cause severe light leaking. Seal your geometry or place hidden thick MeshInstance3D blocks around the exterior.
- **NEVER leave shadow bias at default for cascades** — Default bias often causes Peter Panning or light leaking at split transitions. Tune bias per-light based on your scene's scale.
- **NEVER bake LightmapGI without a Denoiser** — Godot's baked lightmaps are noisy by default. Use OIDN or JNLM (in Project Settings) for professional results.
- **NEVER use real-time SDFGI on Mobile/Compatibility renderers** — It is a Forward+ exclusive feature. Use fake GI bounce lights for lower-end platforms.
- **NEVER use 'Update Continuity' in ReflectionProbes for performance** — Keep ReflectionProbes on 'Update Once' and trigger manual updates only when necessary.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
