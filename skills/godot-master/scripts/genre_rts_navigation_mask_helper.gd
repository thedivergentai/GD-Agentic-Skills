# navigation_mask_helper.gd
extends RefCounted
class_name NavigationMaskHelper

# Navigation Layer Bitmasking for Avoidance
# Dynamically alters agent layers to ignore hazard regions or locked gates.

static func toggle_navigation_layer(agent: NavigationAgent3D, layer_index: int, enabled: bool) -> void:
    # Pattern: Bitwise masking for efficient layer management.
    if enabled:
        agent.navigation_layers |= (1 << layer_index)
    else:
        agent.navigation_layers &= ~(1 << layer_index)

static func set_swimming_capability(agent: NavigationAgent3D, can_swim: bool) -> void:
    # Example: Layer 2 is water.
    toggle_navigation_layer(agent, 2, can_swim)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationlayers.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — dynamic navigation layer bitmasks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
