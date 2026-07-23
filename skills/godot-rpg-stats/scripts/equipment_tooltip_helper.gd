# equipment_tooltip_helper.gd
extends Control
class_name EquipmentTooltipHelper

## Builds BBCode stat diff tooltips for equipment comparison UI.

@export var hovered_stat: RPGStat
@export var equipped_stat: RPGStat


func _make_custom_tooltip(_text: String) -> Object:
	var container := VBoxContainer.new()
	var rtf := RichTextLabel.new()
	rtf.bbcode_enabled = true
	if hovered_stat and equipped_stat:
		var diff := hovered_stat.current_value - equipped_stat.current_value
		var color := "green" if diff > 0 else "red" if diff < 0 else "gray"
		var sign := "+" if diff > 0 else ""
		rtf.text = "[color=%s]%s: %d (%s%d)[/color]" % [
			color, hovered_stat.stat_name, hovered_stat.current_value, sign, diff
		]
	else:
		rtf.text = _text
	container.add_child(rtf)
	return container
