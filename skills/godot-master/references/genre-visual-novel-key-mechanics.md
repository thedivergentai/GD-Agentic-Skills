# Key Mechanics Implementation

### Branching Paths (Flags)
Track decisions to influence future scenes.

```gdscript
func make_choice(choice_id: String) -> void:
    match choice_id:
        "be_nice":
            flags["relationship_alice"] += 1
            jump_to_label("alice_happy")
        "be_mean":
            flags["relationship_alice"] -= 1
            jump_to_label("alice_sad")

### 4. Speaker Z-Ordering (Dynamic Focus)
Bring the active speaker to the front and dim others.

```gdscript
# actor_manager.gd
func focus_speaker(active_name: String) -> void:
    for actor in get_children():
        if not actor is CanvasItem: continue
            
        if actor.name == active_name:
            # Move to bottom of tree to render on top & catch input events
            actor.move_to_front()
            actor.modulate = Color.WHITE
        else:
            # Dim inactive actors
            actor.modulate = Color(0.5, 0.5, 0.5, 1.0)
```

### 5. Asynchronous Background Loading
Prevent stutters when switching high-res assets.

```gdscript
# background_streamer.gd
var _pending_path: String = ""

func load_background(path: String) -> void:
    _pending_path = path
    ResourceLoader.load_threaded_request(path)
    set_process(true)

func _process(_delta: float) -> void:
    var status = ResourceLoader.load_threaded_get_status(_pending_path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        texture = ResourceLoader.load_threaded_get(_pending_path)
        set_process(false)
```

### 6. Emotional BBCode Effects
Use `RichTextLabel` with performance-first `append_text`.

```gdscript
# dialogue_printer.gd
func print_line(speaker: String, text: String, emotion: String) -> void:
    var bb: String = text
    match emotion:
        "angry": bb = "[shake rate=30.0 level=8]%s[/shake]" % text
        "sad": bb = "[wave amp=20.0 freq=2.0]%s[/wave]" % text
    
    # Use append_text to avoid rebuilding the entire tag stack
    append_text("[b]%s:[/b] %s\n" % [speaker, bb])
```
```

### Script Format (JSON vs Resource)
*   **JSON**: Easy to write externally, standard format.
*   **Custom Resource**: Typosafe, editable in Inspector.
*   **Text Parsers**: (e.g., Markdown-like syntax) simpler for writers.
