@tool
class_name DialogueGraphEditor
extends GraphEdit

func link_nodes(from: StringName, from_port: int, to: StringName, to_port: int) -> void:
	var err := connect_node(from, from_port, to, to_port)
	if err == OK:
		print_rich("[color=green]Branch linked.[/color]")
