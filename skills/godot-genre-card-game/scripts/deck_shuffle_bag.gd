# deck_shuffle_bag.gd
# Secure deck randomization using the "Shuffle Bag" pattern
extends Node

# EXPERT NOTE: Shuffle-bag logic prevents streaks of bad luck 
# by ensuring a uniform distribution over the deck lifetime.

var deck: Array[CardData] = []
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func shuffle_deck():
	deck.shuffle() # Engine-level randomized shuffle

func draw_card() -> CardData:
	return deck.pop_back() if !deck.is_empty() else null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — measure streak risk vs shuffle-bag fairness
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed Array pile ops (shuffle/pop_back)
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
