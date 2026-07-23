# App Orchestrator Examples (load on demand)

> **MANDATORY** for clipboard/share flows, service locator registration, and VLS examples beyond [comp_orchestrator_base.gd](../scripts/comp_orchestrator_base.gd).

## Clipboard + toast orchestrator

```gdscript
extends Control

@export var copier: ClipboardCopier
@export var link_label: Label

func _ready() -> void:
	%CopyButton.pressed.connect(_on_copy_button_pressed)
	copier.copy_success.connect(_on_copy_success)

func _on_copy_button_pressed() -> void:
	copier.copy_text(link_label.text)

func _on_copy_success() -> void:
	%ToastNotification.show("Link Copied!")
```

Component: [clipboard_copier.gd](../scripts/clipboard_copier.gd). Auth flows: [`resources/auth_component.gd`](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/resources/auth_component.gd) in this skill package.

## App-level service locator

> **WHY `Engine.register_singleton`:** Avoid dozens of Autoload Nodes for lightweight RefCounted services (Auth, Config).

```gdscript
# AppServiceLocator.gd (Autoload)
func _ready() -> void:
	if not Engine.has_singleton(&"AuthService"):
		Engine.register_singleton(&"AuthService", AuthService.new())

# Anywhere:
var auth = Engine.get_singleton(&"AuthService")
```

## Visual-Logic-Syncer (VLS)

Logic emits; VLS owns `AnimationPlayer` / `modulate` tweens.

```gdscript
@export var logic: AuthComponent
@export var anim: AnimationPlayer

func _ready() -> void:
	logic.login_failed.connect(_on_login_failed)

func _on_login_failed(_reason: String) -> void:
	anim.play("shake_form")
	var t := create_tween()
	t.tween_property(self, "modulate", Color.RED, 0.2)
```

Production: [comp_logic_visual_syncer.gd](../scripts/comp_logic_visual_syncer.gd).

## O(1) component registry

Dashboard orchestrators catalog children once — lookup is orchestrator-private; sideways calls remain forbidden.

```gdscript
var _registry: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		_registry[child.name] = child
		for group in child.get_groups():
			_registry[group] = child

func get_comp(key: StringName) -> Node:
	return _registry.get(key)
```

## Rock test

**MANDATORY** [comp_rock_test_boilerplate.gd](../scripts/comp_rock_test_boilerplate.gd) before shipping new app components.
