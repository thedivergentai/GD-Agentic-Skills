# Core Architecture

```gdscript
# item.gd (Resource)
class_name Item
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var max_stack: int = 1
@export var weight: float = 0.0
@export_multiline var description: String
```
