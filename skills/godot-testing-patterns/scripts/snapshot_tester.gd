# snapshot_tester.gd
# Expert utility for visual regression testing (Snapshot Testing).
# Grounded in Godot 4.x RenderingServer and Image comparison.

extends Node

class_name SnapshotTester

## Takes a screenshot and compares it to a "golden" reference image.
func run_snapshot_test(scene_name: String) -> bool:
	# Wait for frame draw to complete
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	
	var ref_path = "res://tests/snapshots/%s.png" % scene_name
	if not FileAccess.file_exists(ref_path):
		img.save_png(ref_path) # Save first run as reference
		print("Snapshot: Reference saved for %s" % scene_name)
		return true
		
	var ref_img = Image.load_from_file(ref_path)
	var diff = img.compute_image_metrics(ref_img, false)
	
	if diff["max"] > 0.01: # Threshold for drift
		push_error("Snapshot Test FAILED for %s (Diff: %.4f)" % [scene_name, diff["max"]])
		return false
		
	print("Snapshot Test PASSED for %s" % scene_name)
	return true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
# - https://docs.godotengine.org/en/stable/classes/class_viewport.html
# - https://docs.godotengine.org/en/stable/classes/class_image.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — visual drift from theme/layout changes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — golden file I/O patterns for references
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
