# skills/genre-card-game/scripts/card_effect_resolution.gd
extends Node

## Card Effect Resolution (Expert Pattern)
## Implements a LIFO Command stack for resolving card effects and nested reactions.
## Allows for complex chains, counter-play, and sequential animations.

class_name CardEffectResolution

signal effect_started(effect: CardEffect)
signal effect_finished(effect: CardEffect)
signal queue_empty

var effect_queue: Array[CardEffect] = []
var is_resolving: bool = false

# Inner class or external resource for Effect
class CardEffect:
    var source_card: Resource
    var target: Node
    var type: String # DAMAGE, HEAL, DRAW
    var value: int
    
    func execute() -> void:
        # Override this in subclasses
        pass

func add_effect(effect: CardEffect) -> void:
    effect_queue.append(effect)
    if not is_resolving:
        _resolve_next()

func _resolve_next() -> void:
    if effect_queue.is_empty():
        is_resolving = false
        queue_empty.emit()
        return

    is_resolving = true
    var effect = effect_queue.pop_back() # LIFO stack (reactions resolve last-in-first-out)
    
    effect_started.emit(effect)
    
    # Execute logic
    await _execute_effect_logic(effect)
    
    effect_finished.emit(effect)
    
    # Recursive next
    _resolve_next()

func _execute_effect_logic(effect: CardEffect) -> void:
    # In a full system, this would call effect.execute()
    # Here we simulate with a match or generic handler
    print("Resolving Effect: %s on %s" % [effect.type, effect.target])
    
    match effect.type:
        "DAMAGE":
            if effect.target.has_method("take_damage"):
                effect.target.take_damage(effect.value)
        "HEAL":
             if effect.target.has_method("heal"):
                effect.target.heal(effect.value)
    
    # Fake animation delay
    await get_tree().create_timer(0.5).timeout

## EXPERT USAGE:
## When playing a card, instantiate CardEffect and pass to add_effect().
## Listen to signals to block UI during resolution.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — effect_started/finished UI locks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — keyword effects pushed as stack commands
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — damage/heal targets during resolve
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
