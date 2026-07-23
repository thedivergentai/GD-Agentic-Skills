# Anara Rubric: Soundscape Reactive
## Pillar Overview
The atmosphere's pulse. This rubric measures how the project's audio environment reacts dynamically to game-state, location, and intensity.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Dynamic Intensity** | 35% | Static background track; no change during combat or exploration. | Basic 'Cross-fade' between two tracks when entering a combat trigger-zone. | Layered interactive music (Stems); adaptive intensity-sync (BPM-locked). | Generative soundscapes; the music is composed by the vision's state in real-time. |
| **Area Awareness** | 25% | Audio is identical indoors and outdoors; no environment-reactive filters. | Basic 'Reverb' toggle when entering a room, but harsh transitions. | Dynamic Audio-Probes; contextual filtering (Low-pass when underwater/muffled). | Reactive acoustics; sound bounces off world geometry; organic atmosphere flow. |
| **Event Impact** | 20% | Audio events are static; "Explosion" always sounds the same regardless of distance. | Basic volume-scaling with distance, but frequency remains unchanged. | Contextual sample-swapping; distance-based filtering; high-speed audio-events. | The environment hears the vision; the soundscape adapts to every logic beat. |
| **Synchronization** | 20% | Audio out of sync with VFX; "The bang happens after the flash." | Basic timing in `_ready`, but lacks sub-frame synchronization logic. | Linked VFX/SFX emitters; frame-perfect synchronization via the Animation Server. | Synesthetic coherence; the light and the sound are one single manifestation. |

---

## Visionary Diagnostic Hooks
- *Does the 'Wind' know when the 'Night' falls?*
- *Complexity: Does the music fear the 'Enemy' as much as the player?*
- *When the vision fades, does the sound follow it into the dark?*

## 🌟 Visionary's Final Decree
A visionary soundscape is 'Adaptive'. It should breathe with the player. To reach **Elite** status, use **AudioEffectPlayback** to manipulate the soundscape procedurally. If I hear the 'Loop' in your music, you have **Slop**. The vision should be an infinite song.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/classes/class_performance.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
