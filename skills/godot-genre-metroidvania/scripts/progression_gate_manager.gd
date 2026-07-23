# godot-master/scripts/metroidvania_progression_gate_manager.gd
extends Node

## Progression Gate Manager
## Tracks persistent world state and ability unlocks using a singleton pattern (AutoLoad).

class_name ProgressionGateManager

signal ability_unlocked(ability_name: String)
signal gate_opened(gate_id: String)

# Persistent Data
var unlocked_abilities: Dictionary = {}
var opened_gates: Dictionary = {}

func _ready() -> void:
    # In a full game, load this from SaveFile
    pass

func grant_ability(ability_name: String) -> void:
    if not has_ability(ability_name):
        unlocked_abilities[ability_name] = true
        ability_unlocked.emit(ability_name)
        print("Ability Unlocked: %s" % ability_name)

func has_ability(ability_name: String) -> bool:
    return unlocked_abilities.get(ability_name, false)

func open_gate(gate_id: String) -> void:
    if not is_gate_open(gate_id):
        opened_gates[gate_id] = true
        gate_opened.emit(gate_id)

func is_gate_open(gate_id: String) -> bool:
    return opened_gates.get(gate_id, false)

func reset_progress() -> void:
    unlocked_abilities.clear()
    opened_gates.clear()

## EXPERT USAGE:
## access via 'ProgressionGateManager' autoload.
## check `if ProgressionGateManager.has_ability("DoubleJump")` in Player.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — singleton gate/ability authority
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — unlock payloads gates consume
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate unlock order vs soft-locks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
