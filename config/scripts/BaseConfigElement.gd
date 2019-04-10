extends HBoxContainer

class_name BaseConfigElement

var label : String  setget _set_label
var value setget _set_value

func init(new_label : String, new_value) -> void:
	_set_label(new_label)
	_set_value(new_value)

func _set_label(new_label : String) -> void:
	$Label.text = new_label
	label = new_label

func _set_value(new_value) -> void:
	value = new_value