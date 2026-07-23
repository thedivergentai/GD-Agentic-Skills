# Anara Rubric: Procedural Generation
## Pillar Overview
The infinite creation of the vision. This rubric assesses the project's logic for random seed generation, terrain-distribution, and the structural sanity of procedurally created worlds.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Logic Seededness** | 35% | Using `rand()` without a seed; world changes on every reload; non-deterministic. | Use of `RandomNumberGenerator` with a fixed seed, but breaks in sub-generators. | 100% deterministic world-gen; local RNG seeds per sub-system; predictable results. | Meta-seed architecture; infinite world-variation from a single integer; zero-drift. |
| **Structural Sanity** | 25% | Overlapping rooms; unreachable zones; "Floating" tiles; zero-validation. | Grid-based generation, but results in repetitive or 'Lego-like' patterns. | Use of 'WFC' (Wave Function Collapse) or advanced Noise-layers; clear room-connectivity. | High-fidelity organic generation; hierarchical structures (Rooms inside zones); sanity-checked. |
| **Texture & Detail** | 20% | Procedural world looks 'Flat'; no decoration or environmental storytelling. | Basic decorative scattering (e.g. Grass), but lacks clusters or logic. | Proximity-aware scattering; Biomes with distinct asset-sets; procedural foliage maps. | Cinematic proc-gen; the world feels 'Hand-crafted' by the machine's vision. |
| **Gen-Rate Perf.** | 20% | Generation takes 10+ seconds and freezes the main thread; un-chunked. | Async generation via Threads, but still blocks the UI or causes stutter. | Background-thread generation; chunked world-loading; minimal frame-time impact. | Zero-latency generation; predictive world-baking; the vision grows as the player moves. |

---

## Visionary Diagnostic Hooks
- *Is the 'Infinite' a gift or a burden on the vision?*
- *When the world grows, does the machine understand its purpose?*
- *Can I find my way back home in a world that never existed before?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, the generation must be 'Contextual'. It shouldn't just be random; it should tell a story. Use **NoiseTextures** as the seed for your soul. If a player feels the 'Grid' in your procedural world, you have **Slop**. Visionaries make the infinite feel intentional.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
