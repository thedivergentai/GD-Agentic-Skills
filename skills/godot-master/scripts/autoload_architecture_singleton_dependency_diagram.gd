# singleton_dependency_diagram.gd
# Utility to visualize Singleton dependencies and generate a Mermaid diagram.
# Expert tool for managing initialization order.

extends RefCounted

class_name SingletonDependencyDiagram

## Generates a Mermaid 'graph TD' diagram of active Autoloads.
static func generate_mermaid_diagram() -> String:
	var diagram := "graph TD\n"
	
	# Get all children of root (this includes Autoloads)
	var root = Engine.get_main_loop().root
	var autoloads := []
	
	for child in root.get_children():
		# Filter for typical Autoload nodes (exclude the main scene)
		if child.name != "root" and child != Engine.get_main_loop().root.get_child(-1):
			autoloads.append(child)
	
	if autoloads.is_empty():
		return "No Autoloads detected."
		
	for node in autoloads:
		diagram += "  %s[%s]\n" % [node.name, node.name]
		
	# Expert logic: Analyze signals and cross-references (simplified example)
	# In a full implementation, you'd scan script properties for other Autoload names.
	diagram += "\n  %% Manual annotations or analysis result follows\n"
	
	return diagram

## Prints the Mermaid code to console for use in documentation.
static func print_diagram() -> void:
	print(generate_mermaid_diagram())
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — document Autoload order as source of truth
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — visualize circular boot deps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md — architecture docs for agent planning
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
