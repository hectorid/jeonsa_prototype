extends BaseConfigElement

class_name ConfigIntElement

func _set_value(new_value : int) -> void:
	$SpinBox.value = new_value
	value = new_value

func _on_SpinBox_value_changed(new_value : int) -> void:
	value = new_value
