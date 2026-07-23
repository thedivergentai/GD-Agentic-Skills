class_name HSMAnimationSyncer
extends Node

## Expert Logic-to-Animation coupling.
## Keeps AnimationTree in sync with the current HSM state.

@export var anim_tree: AnimationTree
var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	playback = anim_tree.get("parameters/playback")

func sync_state(state_name: String) -> void:
	if playback:
		playback.travel(state_name)

## Rule: Use '.travel()' for smooth blending or '.start()' for instant snaps.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md — travel/start into AnimationNodeStateMachine graphs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — lighter AnimationPlayer sync when no blend tree is needed
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
