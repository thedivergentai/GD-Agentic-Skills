# viewport_3d_preview.gd
# Responsive 3D-in-UI setup using SubViewportContainer [3, 11]
extends SubViewportContainer

@onready var viewport: SubViewport = $SubViewport

func _ready() -> void:
	# stretch = true: The internal viewport size follows the UI container [3]
	stretch = true
	# stretch_shrink: Renders at half resolution for performance while 
	# maintaining UI crispness.
	stretch_shrink = 2 
	
	# Ensure background transparency for HUD overlays
	viewport.transparent_bg = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — preview cameras inside SubViewport
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — stretch_shrink cost tradeoffs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
