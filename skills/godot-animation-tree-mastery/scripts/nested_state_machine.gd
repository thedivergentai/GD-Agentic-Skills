# skills/animation-tree-mastery/code/nested_state_machine.gd
extends AnimationTree

## Hierarchical State Machine Expert Pattern
## Technical blueprints for building complex "Sub-Level" states.

func _ready() -> void:
    # 1. Hierarchy Logic
    # MainSM (Root) -> LocomotionSM (Nested) -> [Idle, Walk, Run]
    
    # 2. Triggering a sub-state transition
    _travel_to_locomotion()

func _travel_to_locomotion() -> void:
    var state_machine_accessor = get("parameters/playback")
    if state_machine_accessor:
        state_machine_accessor.travel("Locomotion")

func set_locomotion_speed(speed: float) -> void:
    # 3. Driving parameters deep inside nested blend trees
    # Expert Path Syntax: "<StateName>/<BlendNodeName>/blend_position"
    set("parameters/Locomotion/BlendSpace2D/blend_position", speed)

## EXPERT NOTE:
## Nested state machines prevent "Spider-Web Graph" syndrome. 
## Keep 'Locomotion', 'Combat', and 'Interaction' as separate sub-graphs.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachine.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodeblendspace2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — keep sub-graphs from becoming spider webs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — nested BlendSpace parameters from movement
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
