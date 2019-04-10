extends BaseConfigElement

class_name ConfigIntElement

func init(new_label : String, new_value : int) -> void:
	._set_label(new_label)
	_set_value(new_value)

func _set_value(new_value : int) -> void:
	$SpinBox.value = new_value
	value = new_value

func _on_SpinBox_value_changed(new_value) -> void:
	value = new_value
