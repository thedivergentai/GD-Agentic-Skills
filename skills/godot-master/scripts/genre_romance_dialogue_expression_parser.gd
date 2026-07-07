extends Node
class_name DialogueExpressionParser

## Expert Dialogue Logic (Godot 4.7).
## Evaluates complex conditions at runtime using the Expression class.

func can_show_choice(condition: String, player_stats: Dictionary) -> bool:
	if condition.is_empty(): return true
	
	var expression = Expression.new()
	# Example: condition = "affection >= 20"
	var error = expression.parse(condition, player_stats.keys())
	
	if error != OK:
		push_error("Dialogue condition parse error: " + expression.get_error_text())
		return false
	
	var result = expression.execute(player_stats.values())
	return result if result is bool else false

## [SKILL NOTICE]: Use 'Expression' to evaluate dialogue conditions. 
## It is much faster and safer than writing a custom logic parser in GDScript.
