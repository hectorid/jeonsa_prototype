extends BaseConfigElement

class_name ConfigFloatElement

func _set_value(new_value : float) -> void:
	$SpinBox.value = new_value
	value = new_value

func _on_SpinBox_value_changed(new_value : float) -> void:
	value = new_value
