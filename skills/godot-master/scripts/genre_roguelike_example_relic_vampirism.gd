# example_relic_vampirism.gd
extends Relic

func on_kill(player: Node, target: Node) -> void:
    player.heal(5)
    print("Vampirism triggered!")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
