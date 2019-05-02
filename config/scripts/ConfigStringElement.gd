extends BaseConfigElement

class_name ConfigStringElement

func _set_value(new_value : String) -> void:
	$LineEdit.text = new_value
	value = new_value

func _on_LineEdit_text_entered(new_text):
	value = new_text
