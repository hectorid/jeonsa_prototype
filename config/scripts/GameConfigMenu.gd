extends Control

const BASE_CONFIG_ELEMENT = preload("res://config/scenes/BaseConfigElement.tscn")
const CONFIG_INT_ELEMENT = preload("res://config/scenes/ConfigIntElement.tscn")
const CONFIG_STRING_ELEMENT = preload("res://config/scenes/ConfigStringElement.tscn")

onready var ConfigList = $CenterContainer/PanelContainer/ScrollContainer/ConfigList

func _ready():
	add_config('test', 10)
	add_config('test', 'batata')
	add_config('test', 30.5)
	add_config('test', 40)

func add_config(name : String, value) -> void:
	var new_element : BaseConfigElement = null
	
	match typeof(value):
		TYPE_INT:
			new_element = CONFIG_INT_ELEMENT.instance()
		TYPE_STRING:
			new_element = CONFIG_STRING_ELEMENT.instance()
		_:
			new_element = BASE_CONFIG_ELEMENT.instance()
		
	
	if new_element != null:
		new_element.init(name, value)
		ConfigList.add_child(new_element)