# animation_condition_sync.gd
extends Node
class_name AnimationConditionSync

# AnimationTree Advance Condition Sync
# Synchronizes internal logic state with AnimationTree parameters safely.

@export var anim_tree: AnimationTree

func update_parameters(moving: bool, attacking: bool) -> void:
    if not anim_tree: return
    
    # Pattern: AnimationTree Advance Conditions are Booleans.
    # NEVER use negation (!) in the editor expression; pass explicit bools.
    anim_tree.set("parameters/conditions/is_moving", moving)
    anim_tree.set("parameters/conditions/is_attacking", attacking)
    
    # Important: Ensure the conditions in the state machine match exactly.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html — Advance Conditions / parameters
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html — set() parameters/conditions/*
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md — clip playback under AnimationTree
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — attack/move FSM drives conditions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
