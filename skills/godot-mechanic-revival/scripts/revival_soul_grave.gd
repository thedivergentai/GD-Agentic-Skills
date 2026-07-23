class_name RevivalSoulGrave
extends Node3D

## Expert Soul Retrieval (Dark Souls style).
## Persistence object left at death site containing lost resources.

var lost_currency: int = 0

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("add_currency"):
			body.add_currency(lost_currency)
		queue_free()

## Rule: Ensure graves are spawned slightly above the ground offset to avoid physics clipping.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html — Player group pickup check
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html — grave scene instantiate at death site
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — add_currency ledger safety
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md — souls-like retrieval loop
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
