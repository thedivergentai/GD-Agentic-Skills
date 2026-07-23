# Aurelius Protocol: Genre Rhythm NEVER List

- NEVER use `Time.get_ticks_msec()` for rhythm sync; strictly use **`AudioServer.get_time_since_last_mix()`** combined with latency offsets for sub-frame accuracy.
- NEVER process song logic in `_process()`; strictly use **`_physics_process()`** or a conductor loop to ensure deterministic timing regardless of render frames.
- NEVER use `_process()` to capture hit inputs; strictly use **`_input(event)`** to record the exact timestamp of the button press event.
- NEVER scale engine time_scale for song speed; strictly use **`AudioStreamPlayer.pitch_scale`** to adjust speed and avoid globally breaking physics logic.
- NEVER ignore **Audio Latency Calibration**; strictly provide a manual offset menu to compensate for varied hardware (Bluetooth vs Wired).
- NEVER use `yield` or `await` for beat timing; strictly use a sample-accurate **Delta Accumulator** tied to the audio clock.
- NEVER assume a constant BPM; strictly build your conductor to handle a **Tempo Map** for complex track changes.
- NEVER judge inputs based on world position (pixels); strictly judge against the **Song's Elapsed Time (ms)** to ensure consistency across resolutions.
- NEVER play hit sounds with static pitch; strictly add **±5% Random Pitch Variation** to hit sounds to avoid the "machine gun" effect.
- NEVER use tight timing windows (e.g., <25ms) for all players; strictly use **Wider Windows for Beginners** to prevent immediate frustration.
- NEVER instantiate note nodes every beat; strictly use **Object Pooling** to recycle note instances and prevent GC spikes during dense tracks.
- NEVER use standard Area2D signals for rhythmic hits; strictly **Poll Inputs** in the conductor loop to compare against target timestamps.
- NEVER calculate FFT for visualization on the main thread; strictly use **AudioEffectSpectrumAnalyzerInstance** for optimized engine-side analysis.
- NEVER allow note spamming/mashing; strictly penalize misses or break combos to maintain the game's integrity.
- NEVER use `load()` dynamically during gameplay; strictly use **ResourceLoader.load_threaded_request()** to avoid thread stalling.
- NEVER forget to pause the conductor/ highway; strictly sync with the audio player's pause state to prevent notes from scrolling while the music is stopped.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rhythm/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
