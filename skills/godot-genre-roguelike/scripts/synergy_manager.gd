# synergy_manager.gd
func check_synergies(inventory: Array[ItemData]):
    var tags = {}
    for item in inventory:
        for tag in item.synergy_tags:
            tags[tag] = tags.get(tag, 0) + 1
            
    if tags.get(&"Fire", 0) >= 1 and tags.get(&"Projectile", 0) >= 1:
        activate_synergy(&"Flaming_Arrow")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
