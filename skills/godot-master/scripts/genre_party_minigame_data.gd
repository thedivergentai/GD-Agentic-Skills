# minigame_data.gd
class_name MinigameData extends Resource

@export var title: String
@export var scene_path: String
@export var instructions: String
@export var is_1v3: bool = false
@export var thumbnail: Texture2D
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
