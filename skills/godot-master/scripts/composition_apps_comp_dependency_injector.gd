class_name CompDependencyInjector
extends Node

## Expert Runtime Dependency Injection.
## Use when components are added dynamically and need references.

func inject(deps: Dictionary) -> void:
	for key in deps:
		if key in self:
			set(key, deps[key])

## Rule: Use injection to avoid 'get_node' or 'get_parent' inside dynamic components.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — reinject deps after dynamic spawn
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — set()/property injection without get_node
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
