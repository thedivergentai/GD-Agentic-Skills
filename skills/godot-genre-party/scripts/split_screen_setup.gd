extends GridContainer

## Expert Split-Screen Layout (Godot 4.7).
## Standard 2-4 player grid configuration.

func setup(players: int) -> void:
	# Clear existing
	for c in get_children(): c.queue_free()
	
	columns = 2 if players > 1 else 1
	
	for i in range(players):
		var container = SubViewportContainer.new()
		container.stretch = true
		container.size_flags_horizontal = SIZE_EXPAND_FILL
		container.size_flags_vertical = SIZE_EXPAND_FILL
		
		var viewport = SubViewport.new()
		var cam = Camera3D.new() # Or Camera2D
		
		add_child(container)
		container.add_child(viewport)
		viewport.add_child(cam)

## [SKILL NOTICE]: Use 'SubViewportContainer' with 'stretch=true'. 
## For adaptive split-screen (merging), use a custom shader on a ColorRect.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_gridcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — 1–4 player column grid
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — spawn camera per viewport
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
