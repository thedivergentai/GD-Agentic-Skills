# Aurelius Protocol: Audio Systems NEVER List

- **NEVER set bus volume with linear values** — `set_bus_volume_db()` is logarithmic. Use `linear_to_db()` for sliders OR everything will sound too loud until the last 5%.
- **NEVER skip 'Bus Routing'** — Playing music on the 'SFX' bus makes volume menus useless. Strictly route every player to its dedicated sub-bus (Music, SFX, UI, Voice).
- **NEVER use 'Master' for gameplay sounds** — Dedicate Master to final limiting. Route all gameplay to sub-groups so you can mute/duck categories.
- **NEVER use 3D players without an Attenuation Model** — Default is NONE. If you don't set it to `Inverse Distance`, a whisper on the other side of the map will be global volume.
- **NEVER play 3D sounds exactly on top of the listener** — Causes "Panning Jitter" where the sound snaps between Left/Right speakers. Offset by `0.1` units.
- **NEVER forget Doppler for high-speed objects** — A car flying by without `DOPPLER_TRACKING_PHYSICS_STEP` feels flat and static.
- **NEVER spam same-frame sounds** — Playing 50 explosions at once causes constructive interference (clipping/distortion). Use a `Limiter` (`audio_voice_limiter_manager.gd`).
- **NEVER instantiate nodes for one-shots** — Creating a node, playing a 0.5s clap, and `queue_free()`ing causes frame-time spikes. Use a Pool.
- **NEVER skip Crossfades/Transitions** — Abrupt music cuts break immersion. Always use a 0.5s-1.0s `Tween` to bridge tracks.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
