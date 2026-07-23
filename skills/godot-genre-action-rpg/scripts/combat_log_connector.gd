# combat_log_connector.gd
extends Node
class_name CombatLogConnector

# Signal-Driven Combat Log (Dependency Injection)
# Connects combat events to UI/Logging systems without hardcoding references.

func connect_entity(entity: Node) -> void:
    # Pattern: Bind metadata like entity name to the signal callback.
    if entity.has_signal(&"health_changed"):
        entity.health_changed.connect(_on_health_update.bind(entity.name))

func _on_health_update(new_val: int, entity_name: String) -> void:
    # Centralized event handling (e.g., adding to a UI RichTextLabel).
    print("[Combat] ", entity_name, " health updated to: ", new_val)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — bind metadata on connect
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — inject listeners, do not hardcode UI
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — health_changed ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — entity damage events
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
