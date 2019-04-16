extends HBoxContainer

class_name BaseConfigElement

var section : String
var key : String

var label : String  setget _set_label
var value setget _set_value

func init(new_section : String, new_key : String, new_value) -> void:
	section = new_section
	key = new_key
	_set_label(new_key + ' : ERROR')
	_set_value(new_value)

func _set_label(new_label : String) -> void:
	$Label.text = new_label
	label = new_label

func _set_value(new_value) -> void:
	value = new_value