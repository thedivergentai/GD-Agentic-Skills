# safe_type_casting.gd
# Using 'as' for crash-proof object identification
extends Area2D

# EXPERT NOTE: Avoid 'is' followed by a hard cast. Use 'as' and 
# check for null to prevent runtime crashes on mismatch.

func _on_body_entered(body: Node2D) -> void:
	# Safe cast: returns null if body is not the class/script
	var player := body as CharacterBody2D
	
	if player and player.has_method("apply_damage"):
		player.call("apply_damage", 10)
	else:
		# Not a player, ignore safely
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — safe `as` on body_entered payloads
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — cast hitboxes without hard-cast crashes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
