# Interactive Music Deep-Dive

Use this reference only when implementing horizontal/vertical adaptive scores. Prefer the scripts in the parent skill; do not paste large managers into SKILL.md.

## Horizontal re-sequencing (`AudioStreamInteractive`)

State-machine of clips with transition rules that snap to beat/bar boundaries (explore → combat). Wire via [interactive_music_graph.gd](../scripts/interactive_music_graph.gd).

## Vertical layering (`AudioStreamSynchronized`)

Multiple stems stay sample-locked. Fade stems with `set_sync_stream_volume(index, db)` over 1–2s Tweens based on intensity. Wire via [audio_interactive_music_manager.gd](../scripts/audio_interactive_music_manager.gd).

## Rules

- Never hard-cut music; always crossfade or interactive transition.
- Keep Music on its own bus; duck under Dialogue with [audio_bus_ducker_logic.gd](../scripts/audio_bus_ducker_logic.gd).
- Intensity should be a 0–1 gameplay signal, not a direct bus-volume write from combat code every frame.

## Docs

- https://docs.godotengine.org/en/stable/classes/class_audiostreaminteractive.html
- https://docs.godotengine.org/en/stable/classes/class_audiostreamsynchronized.html
- https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
