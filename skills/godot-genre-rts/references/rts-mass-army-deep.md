# RTS Mass Army & Fog Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Selection Manager (Singleton or Commander Node)
Handles mouse input for selecting units.

```gdscript
# selection_manager.gd
extends Node2D

var selected_units: Array[Unit] = []
var drag_start: Vector2
var is_dragging: bool = false
@onready var selection_box: Panel = $SelectionBox

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            start_selection(event.position)
        else:
            end_selection(event.position)
    elif event is InputEventMouseMotion and is_dragging:
        update_selection_box(event.position)

func end_selection(end_pos: Vector2):
    is_dragging = false
    selection_box.visible = false
    var rect = Rect2(drag_start, end_pos - drag_start).abs()
    
    if Input.is_key_pressed(KEY_SHIFT):
        # Add to selection
        pass
    else:
        deselect_all()
        
    # Query physics server for units in rect
    var query = PhysicsShapeQueryParameters2D.new()
    var shape = RectangleShape2D.new()
    shape.size = rect.size
    query.shape = shape
    query.transform = Transform2D(0, rect.get_center())
    # ... execute query and add units to selected_units
    
    for unit in selected_units:
        unit.set_selected(true)

func issue_command(target_position: Vector2):
    for unit in selected_units:
        unit.move_to(target_position)
```

### 2. Unit Controller (State Machine)
Units need robust state management to handle commands and auto-attacks.

```gdscript
# unit.gd
extends CharacterBody2D
class_name Unit

enum State { IDLE, MOVE, ATTACK, HOLD }
var state: State = State.IDLE
var command_queue: Array[Command] = []

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func move_to(target: Vector2):
    nav_agent.target_position = target
    state = State.MOVE

func _physics_process(delta):
    if state == State.MOVE:
        if nav_agent.is_navigation_finished():
            state = State.IDLE
            return
            
        var next_pos = nav_agent.get_next_path_position()
        var direction = global_position.direction_to(next_pos)
        velocity = direction * speed
        move_and_slide()

### 3. Group Movement & Flocking
Instead of moving all units directly to a single point (clumping), use **Relative Offsets**:
- Calculate the **Center of Mass** for the selected group.
- On click, calculate each unit's **Relative Offset** from the center.
- Issue `target_position + unit_offset` to each unit to maintain formation.
```

### 3. Fog of War
A system to hide unvisited areas. Usually implemented with a texture and a shader.

*   **Grid Approach**: 2D array of "visibility" values.
*   **Viewport Texture**: A `SubViewport` drawing white circles for units on a black background. This texture is then used as a mask in a shader on a full-screen `ColorRect` overlay.

```gdshader
shader_type canvas_item;
uniform sampler2D visibility_texture; 
uniform vec4 fog_color : source_color;

void fragment() {
    float visibility = texture(visibility_texture, UV).r;
    COLOR = mix(fog_color, vec4(0,0,0,0), visibility);
}
```

---

## Key Mechanics Implementation

### Command Queue
Allow players to chain commands (Shift-Click).
*   **Implementation**: Store commands in an `Array`. When one finishes, pop the next.
*   **Visuals**: Draw lines showing the queued path.

### Resource Gathering
*   **Nodes**: `ResourceNode` (Tree/GoldMine) and `DropoffPoint` (TownCenter).
*   **Logic**:
    1.  Move to Resource.
    2.  Work (Timer).
    3.  Move to Dropoff.
    4.  Deposit (Global Economy update).
    5.  Repeat.

---

## Godot-Specific Tips

*   **Avoidance**: `NavigationAgent2D` has built-in RVO avoidance. Make sure to call `set_velocity()` and use the `velocity_computed` signal for the actual movement!
*   **Server Architecture**: For 100+ units, don't use `_process` on every unit. Have a central `UnitManager` iterate through active units to save function call overhead.
*   **Groups**: Use Groups heavily (`Units`, `Buildings`, `Resources`) for easy selection filters.


---

---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Center-of-Mass Formation Movement Pattern
To prevent CPU bottlenecks when moving hundreds of units, avoid querying individual paths. Instead, calculate the "Center of Mass" of the selection and perform a single `NavigationServer3D` (or 2D) path query.

```gdscript
class_name RTSFormationManager extends Node

---

## Moves a group of units in formation to a target destination using a single path query.
static func move_group_to_target(units: Array[CharacterBody3D], target_position: Vector3, map_rid: RID) -> void:
    if units.is_empty():
        return
        
    # 1. Calculate the Center of Mass (Average Position)
    var center_of_mass := Vector3.ZERO
    for unit in units:
        center_of_mass += unit.global_position
    center_of_mass /= units.size()
    
    # 2. Query NavigationServer for the optimized central path
    var central_path: PackedVector3Array = NavigationServer3D.map_get_path(
        map_rid,
        center_of_mass,
        target_position,
        true 
    )
    
    if central_path.is_empty():
        return
        
    var final_center_destination: Vector3 = central_path[central_path.size() - 1]
    
    # 3. Distribute commands with relative offsets to maintain formation
    for unit in units:
        var offset: Vector3 = unit.global_position - center_of_mass
        var unit_destination: Vector3 = final_center_destination + offset
        
        if unit.has_method("set_movement_target"):
            unit.set_movement_target(unit_destination)
```

### 2. MultiMeshInstance Rendering for Massive Armies
Standard nodes fail when unit counts reach thousands. Use `MultiMeshInstance3D` to draw millions of objects in a single draw call via the GPU.

- **Architectural Tip**: Pre-allocate the maximum expected units and toggle visibility via `visible_instance_count`.
- **Performance**: Note that individual frustum culling is disabled for MultiMesh instances; the entire group is either drawn or not.

```gdscript
class_name RTSMassiveUnitRenderer extends MultiMeshInstance3D

@export var max_units: int = 10000
@export var unit_mesh: Mesh

func _ready() -> void:
    multimesh = MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.use_colors = true 
    multimesh.instance_count = max_units
    multimesh.mesh = unit_mesh
    multimesh.visible_instance_count = 0

---

## Sync logical unit transforms to GPU instances
func synchronize_rendering(active_units: Array[Transform3D]) -> void:
    var count: int = min(active_units.size(), max_units)
    multimesh.visible_instance_count = count
    
    for i in range(count):
        multimesh.set_instance_transform(i, active_units[i])
```

### 3. SubViewport Fog-of-War System
Avoid complex geometry. Use a `SubViewport` as a dynamic render target to generate a vision mask (White = Vision, Black = Fog).

**Mask Generator Logic:**
```gdscript
class_name FogOfWarManager extends SubViewport

@export var terrain_material: ShaderMaterial
@export var world_bounds: Vector2 = Vector2(1024, 1024)

func _ready() -> void:
    disable_3d = true 
    render_target_update_mode = SubViewport.UPDATE_ALWAYS
    
    await RenderingServer.frame_post_draw 
    var fow_texture: ViewportTexture = get_texture()
    terrain_material.set_shader_parameter("fow_mask", fow_texture)
    terrain_material.set_shader_parameter("world_bounds", world_bounds)
```

**Projection Shader (Spatial):**
```glsl
shader_type spatial;
uniform sampler2D fow_mask : hint_default_black, filter_linear;
uniform vec2 world_bounds;
uniform vec3 fog_color : source_color = vec3(0.1, 0.1, 0.15);

void fragment() {
    // Map World X/Z to 2D UV Coordinates
    vec2 fow_uv = (NODE_POSITION_WORLD.xz / world_bounds) + vec2(0.5);
    float visibility = texture(fow_mask, fow_uv).r;
    
    ALBEDO = mix(fog_color, ALBEDO, visibility);
}
```


- Master Skill: [godot-master](../godot-master/SKILL.md)
