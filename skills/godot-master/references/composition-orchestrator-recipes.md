# Orchestrator Recipes (load on demand)

> **MANDATORY** when wiring Input → Movement → Health orchestrators beyond [composition_root_init.gd](../scripts/composition_composition_root_init.gd). Components live in `scripts/` — this file holds pedagogy only.

## Typed export orchestrator

```gdscript
class_name Player extends CharacterBody3D

@export var health_component: HealthComponent
@export var movement_component: VelocityComponent
@export var input_component: Node  # project-specific InputComponent

func _physics_process(delta: float) -> void:
	if input_component.has_method(&"update"):
		input_component.call(&"update")
	if movement_component and input_component.has_method(&"get_move_dir"):
		var dir: Vector2 = input_component.call(&"get_move_dir")
		movement_component.tick(delta, dir)
```

## Input component (senses only)

Reads hardware; does not move the body.

```gdscript
class_name InputComponent extends Node

var move_dir: Vector2
var jump_pressed: bool

func update() -> void:
	move_dir = Input.get_vector("left", "right", "up", "down")
	jump_pressed = Input.is_action_just_pressed("jump")
```

Prefer [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) for action maps.

## Movement component (legs)

```gdscript
class_name MovementComponent extends Node

@export var body: CharacterBody3D
@export var speed: float = 8.0
@export var jump_velocity: float = 12.0

func tick(delta: float, direction: Vector2, wants_jump: bool) -> void:
	if not body:
		return
	if not body.is_on_floor():
		body.velocity.y -= 9.8 * delta
	body.velocity.x = direction.x * speed if direction else move_toward(body.velocity.x, 0, speed)
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump_velocity
	body.move_and_slide()
```

Production movement: [velocity_component.gd](../scripts/composition_velocity_component.gd).

## Health component

[health_component.gd](../scripts/composition_health_component.gd) — context-agnostic HP; orchestrator connects `died` to despawn/VFX.

## State-component FSM

[state_component_vsm.gd](../scripts/composition_state_component_vsm.gd) — child nodes as states. Deeper FSMs: [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md).

## Component registry

O(1) lookup by name or group — orchestrator-private; still no sideways sibling calls.

```gdscript
var _components: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		_components[child.name] = child
		for group in child.get_groups():
			_components[group] = child

func get_comp(key: StringName) -> Node:
	return _components.get(key)
```

## Dependency validation

> **CAUTION:** `assert()` strips in release — use `@export` typed slots + null checks for shipping builds.

```gdscript
@export var health_component: HealthComponent

func _ready() -> void:
	assert(health_component != null, "Missing HealthComponent export!")
```
