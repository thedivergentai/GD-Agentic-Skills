# Elite Dialogue Patterns (load on demand)

> **MANDATORY** for GraphEdit authoring tools, TTS/lipsync, choice analytics, and NPC interaction wiring beyond the Resource Autoload golden path.

## GraphEdit auditor (@tool)

[dialogue_graph_editor.gd](../scripts/dialogue_graph_editor.gd) — editor-only visual linking; **export** to [dialogue_resource.gd](../scripts/dialogue_resource.gd) or JSON for runtime. Never ship GraphEdit as the runtime walker.

## Audio-driven lines (TTS / lipsync)

> **CAUTION:** Still allow skip — snap `visible_ratio` / stop TTS on advance input.

[dialogue_lipsync.gd](../scripts/dialogue_lipsync.gd) — `DisplayServer.tts_speak` + boundary callbacks for viseme timing.

## Choice analytics

> **WHY custom Logger:** Keeps I/O out of conversation nodes; prefix `[CHOICE]` lines for funnel tuning (no PII).

[dialogue_stat_logger.gd](../scripts/dialogue_stat_logger.gd) — register via `OS.add_logger` in boot Autoload.

## NPC interaction (signal-up)

```gdscript
extends CharacterBody2D

@export var dialogue: DialogueResource

func interact() -> void:
	DialogueManagerSingleton.start_dialogue(dialogue)
```

Never `get_node()` into UI from NPC scripts.

## Localization keys

Use `text_key` + `tr()` — [localized_dialogue_resource.gd](../scripts/localized_dialogue_resource.gd). CSV import: Godot i18n docs.

## Voice acting (pre-recorded)

```gdscript
@onready var voice_player := $AudioStreamPlayer

func play_voice_line(line_id: String) -> void:
	var audio := load("res://voice/" + line_id + ".mp3")
	if audio:
		voice_player.stream = audio
		voice_player.play()
```

Drive typewriter length from clip duration when using [typebox_effect.gd](../scripts/typebox_effect.gd) — still honor skip.

## Inline manager tutorial (moved)

Runtime walkers: [dialogue_manager_singleton.gd](../scripts/dialogue_manager_singleton.gd) (Resource) or [dialogue_engine.gd](../scripts/dialogue_engine.gd) (JSON). Pick **one** engine per project.

## Dialogue graph Resource shape

```gdscript
class_name DialogueGraph extends Resource

@export var lines: Dictionary = {}  # line_id -> DialogueNode
```

Production nodes: [dialogue_node_data.gd](../scripts/dialogue_node_data.gd), [dialogue_option_data.gd](../scripts/dialogue_option_data.gd).
