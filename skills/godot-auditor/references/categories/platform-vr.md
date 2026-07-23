# Aurelius Protocol: Platform Vr NEVER List

- **NEVER drop below 90 FPS** — In VR, 72 FPS or less causes instant nausea. You MUST maintain at least 90 FPS (Meta Quest 2/3 typical) and minimize rendering jank.
- **NEVER use smooth rotation without a vignette (comfort mask)** — Smooth rotation causes motion sickness. Always provide snap turning OR dynamic vignetting.
- **NEVER force 3D MSAA if Foveated Rendering is enabled** — Foveation can conflict with MSAA natively in the OpenXR pipeline on some hardware.
- **NEVER skip a teleport locomotion option** — Smooth movement is intolerable for many. Always offer teleportation as an accessibility alternative.
- **NEVER use billboarding for VR UI** — `BILLBOARD_ENABLED` breaks stereoscopic depth cues. Use static `MeshInstance3D` planes with `SubViewports`.
- **NEVER place UI too close or too far** — 0.5m causes eye strain; 10m is unreadable. Optimal distance is 1-3 meters from the player.
- **NEVER forget to respect physical play area boundaries** — Stepping into real-world objects is a safety risk. Use `XRServer` to fetch guardian bounds.
- **NEVER ignore focus_lost or session_ended signals** — Gracefully handle disconnections or system menu overlays by pausing the simulation.
- **NEVER hardcode XRControllerTracker names** — Use the **OpenXR Action Map** system to decouple gameplay from specific hardware labels.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
